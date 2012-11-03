module Levels
  # A merged group contains the union of keys from a set of groups. However,
  # the value of a key is the value of the last group.
  class MergedGroup
    include Levels::MethodMissing

    # Internal: Initialize a merged group.
    #
    # name   - Symbol the group name.
    # groups - Array of Levels::Group.
    #
    def initialize(name, groups, event_handler = nil, lazy_evaluator = nil)
      @name = name
      @groups = groups
      @event_handler = event_handler || Levels::NullEventHandler.new
      @lazy_evaluator = lazy_evaluator || -> value { value }
    end

    # See Levels::Group#[].
    def [](key)
      groups = @groups.find_all { |group| group.defined?(key) }
      raise UnknownKey if groups.empty?

      names  = groups.map { |g| g._level_name }
      values = groups.map { |g| @lazy_evaluator.call(g[key]) }

      # Notify that a key was read, and all of the values.
      @event_handler.on_read_from_merged_group(
        @name,
        key,
        names.zip(values)
      )

      # Return the last value.
      values.last
    end

    # See Levels::Group#defined?
    def defined?(key)
      @groups.any? { |group| group.defined?(key) }
    end

    def to_s
      "<Levels::MergedGroup #{name}>"
    end

    # Returns an Enumerator which yields [key, value].
    def to_enum
      Enumerator.new do |y|
        keys = Set.new
        @groups.each do |group|
          group.to_enum.each do |key, value|
            keys << key
          end
        end
        keys.each do |key|
          y << [key, self[key]]
        end
      end
    end
  end
end
