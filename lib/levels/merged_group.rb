module Levels
  # A merged group contains the union of keys from a set of groups. However,
  # the value of a key is the value of the last group.
  class MergedGroup
    include Levels::MethodMissing

    # Internal: Initialize a merged group.
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
    # Raises Levels::UnknownKey if the value is not defined.
    def [](value_key)
      raise UnknownKey unless self.defined?(value_key)
      values = @group_observer.observe_values(@levels, @group_key, value_key)
      values.final_value
    end

    # Public: Determine if a value is defined.
    #
    # value_key - Symbol name of the value.
    #
    # Returns a Boolean.
    def defined?(value_key)
      groups.any? { |group| group.defined?(value_key) }
    end

    def to_s
      "<Levels::MergedGroup #{@group_key}>"
    end

    # Returns an Enumerator which yields [key, value].
    def to_enum
      Enumerator.new do |y|
        value_keys = Set.new
        groups.each do |group|
          group.to_enum.each do |key, value|
            value_keys << key
          end
        end
        value_keys.each do |key|
          y << [key, self[key]]
        end
      end
    end

  protected

    def groups
      levels = @levels.find_all { |level| level.defined?(@group_key) }
      levels.map { |level| level[@group_key] }
    end
  end
end
