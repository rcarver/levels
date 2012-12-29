module Levels
  module Audit
    # The Value represents one piece of configuration data that was originally
    # stored in a Level.
    class Value

      # Initialize a new Value.
      #
      # level_name - String the name of the level this value was in.
      # final      - Boolean true if this is the "final" value for a set of
      #              levels.
      #
      def initialize(level_name, final, value = :__no_value__)
        @level_name = level_name
        @final = final
        @nested_group_observers = []
        if value == :__no_value__
          @value = yield self if block_given?
        else
          @value = value
        end
      end

      # Returns a String the name of the level.
      attr_reader :level_name

      # Returns the actual value.
      attr_reader :value

      # Returns the actual value.
      alias raw value

      # Returns a Boolean true if this is the final value.
      def final?
        !!@final
      end

      # Returns a Boolean true if this value is recursive.
      def recursive?
        !@nested_group_observers.empty?
      end

      # Public: Trigger a notification of the nested values. For any nested
      # values, the event handler will receive the `#on_nested_values` message.
      #
      # event_handler - Levels::EventHandler.
      def notify(event_handler)
        @nested_group_observers.each do |ngo|
          ngo.notify_nested(event_handler)
        end
      end

      # Private: This is used to accumulate recursive group access.
      def add_nested_group_observer(nested_group_observer)
        @nested_group_observers << nested_group_observer
      end

      def inspect
        value.inspect
      end
    end
  end
end

