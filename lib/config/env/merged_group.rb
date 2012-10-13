module Config
  module Env
    # A merged group contains the union of keys from a set of groups. However,
    # the value of a key is the value of the last group.
    class MergedGroup
      include Config::Env::MethodMissing

      # Internal: Initialize a merged group.
      #
      # name   - Symbol the group name.
      # groups - Array of Config::Env::Group.
      #
      def initialize(name, groups)
        @name = name
        @groups = groups
        @event_handler = Config::Env.event_handler
      end

      # See Config::Env::Group#[].
      def [](key)
        groups = @groups.find_all { |group| group.defined?(key) }
        raise UnknownKey if groups.empty?

        # Notify that a key was read.
        @event_handler.on_read_from_merged_group(
          @name,
          key,
          groups.map { |g| [g._level_name, g[key]] }
        )

        # Return the value.
        groups.last[key]
      end

      # See Config::Env::Group#defined?
      def defined?(key)
        @groups.any? { |group| group.defined?(key) }
      end

      def to_s
        "<Config::Env::MergedGroup #{name}>"
      end

      # Dependency Injection for testing.
      attr_writer :event_handler
    end
  end
end
