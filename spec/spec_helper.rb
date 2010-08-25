require 'rubygems'
require 'rspec'
require 'active_support'
require 'active_record'
require 'action_controller'
require 'action_view'
require 'matchers'
require 'cancan'
require 'cancan/matchers'

RSpec.configure do |config|
  config.mock_with :rr
  # config.filter_run :focus => true
  # config.run_all_when_everything_filtered = true
end

class Ability
  include CanCan::Ability

  def initialize(user)
  end
end

# this class helps out in testing nesting and SQL conditions
class Person
  def self.sanitize_sql(hash_cond)
    case hash_cond
    when Hash
      sanitize_hash(hash_cond).join(' AND ')
    when Array
      hash_cond.shift.gsub('?'){"#{hash_cond.shift.inspect}"}
    when String then hash_cond
    end
  end

  def self.sanitize_hash(hash)
    hash.map do |name, value|
      if Hash === value
        sanitize_hash(value).map{|cond| "#{name}.#{cond}"}
      else
        "#{name}=#{value}"
      end
    end.flatten
  end
end
