module Levels
  module Audit
    class RootObserver

      def initialize(lazy_evaluator)
        @lazy_evaluator = lazy_evaluator
        @current_value_stack = []
      end

      def observe_group(user_observer)
        if current_value
          observer = NestedGroupObserver.new(value_observer)
          current_value.add_nested_group_observer(observer)
          observer
        else
          GroupObserver.new(value_observer, user_observer)
        end
      end

      def with_current_value(value)
        begin
          @current_value_stack << value
          yield
        ensure
          @current_value_stack.pop
        end
      end

      def current_value
        @current_value_stack.last
      end

    protected

      def value_observer
        ValueObserver.new(self, @lazy_evaluator)
      end
    end
  end
end


