module Levels
  module Audit
    # The GroupObserver notifies when a value is accessed.
    class GroupObserver

      # Initialize a new GroupObserver.
      #
      # value_observer - Levels::Audit::ValueObserver.
      # event_handler  - Levels::EventHandler.
      #
      def initialize(value_observer, event_handler)
        @value_observer = value_observer
        @event_handler = event_handler
      end

      # Retrieve the value at a group+value key and notify that it was read.
      #
      # Returns a Levels::Audit::Values.
      def observe_values(levels, group_key, value_key)
        values = @value_observer.observe_values(levels, group_key, value_key)
        @event_handler.on_values(values)
        values
      end
    end
  end
end
