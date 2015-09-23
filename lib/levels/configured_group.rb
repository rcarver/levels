module Levels
  # A ConfiguredGroup is the union of one or more Groups. When a key is read,
  # the value returned is the value from the last Level that defines that key.
  class ConfiguredGroup
    include Levels::MethodMissing

    # Internal: Initialize a configured group.
    #
    def initialize(levels, group_key, group_observer)
      @levels = levels
      @group_key = group_key
      @group_observer = group_observer
    end

    # Public: Retrieve a value.
    #
    # value_key - Symbol name of the value.
    #
    # Returns the value stored at that key.
    # Raises Levels::UnknownKey if the key is not defined.
    def [](value_key)
      raise UnknownKey unless self.defined?(value_key)
      audit_values = @group_observer.observe_values(@levels, @group_key, value_key)
      audit_values.final_value
    end

    # Public: Determine if a key is defined.
    #
    # value_key - Symbol name of the key.
    #
    # Returns a Boolean.
    def defined?(value_key)
      groups.any? { |group| group.defined?(value_key) }
    end

    def to_s
      "<Levels::ConfiguredGroup #{@group_key}>"
    end

    # Returns an Enumerator which yields [key, value]. The key is a Symbol
    #   and the value is any object.
    def to_enum
      Enumerator.new do |y|
        value_keys = Set.new
        groups.each do |group|
          group.to_enum.each do |key, value|
            value_keys << key
          end
        end
        value_keys.each do |key|
          y << [key.to_sym, self[key].value]
        end
      end
    end

  protected

    def groups
      levels = @levels.find_all { |level| level.defined?(@group_key) }
      levels.map { |level| level[@group_key] }
    end

    # Returns a Levels::Value.
    # Raises Levels::UnknownKey if the key is not defined.
    def value_for(value_key)
    end
  end
end
