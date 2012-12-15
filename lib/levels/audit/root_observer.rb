module Levels
  module Audit
    # The RootObserver observes all accesses to group and value data.
    class RootObserver

      # Initialize a new RootObserver
      #
      # evaluator - Ducktype #call used to interpret raw values.
      #
      def initialize(evaluator)
        @evaluator = evaluator
        @current_value_stack = []
      end

      # Get an observer to watch when values are accessed from a group.
      #
      # event_handler - Levels::EventHandler to receive observations.
      #
      # Returns a Levels::Audit::GroupObserver.
      def observe_group(user_observer)
        if current_value
          observer = NestedGroupObserver.new(value_observer)
          current_value.add_nested_group_observer(observer)
          observer
        else
          GroupObserver.new(value_observer, user_observer)
        end
      end

      # Private: Set the current value context. This is used to capture
      # recursive values.
      #
      # value - Levels::Audit::Value.
      #
      # Yields.
      #
      # Returns nothing.
      def with_current_value(value)
        begin
          @current_value_stack << value
          yield
        ensure
          @current_value_stack.pop
        end
      end

      # Private: Get the current value.
      #
      # Returns a Levels::Audit::Value or nil.
      def current_value
        @current_value_stack.last
      end

    protected

      def value_observer
        ValueObserver.new(self, @evaluator)
      end
    end
  end
end


