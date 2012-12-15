module Levels
  module Audit
    # The NestedGroupObserver is like a GroupObserver, but used to
    # observe what happens during recursive value evaluation.
    class NestedGroupObserver

      # Initialize a new NestedGroupObserver.
      #
      # value_observer - Levels::Audit::ValueObserver.
      #
      def initialize(value_observer)
        @value_observer = value_observer
        @values = []
      end

      # Retrieve the value at a group+value key.
      #
      # Returns a Levels::Audit::Values.
      def observe_values(levels, group_key, value_key)
        values = @value_observer.observe_values(levels, group_key, value_key)
        @values << values
        values
      end

      # Private: Notify that the observed values were seen. After notifying of
      # the observed values, the set of observed values is reset.
      #
      # event_handler - Levels::EventHandler.
      #
      # Returns nothing.
      def notify_nested(event_handler)
        @values.each { |v| event_handler.on_nested_values(v) }
        @values.clear
      end
    end
  end
end
