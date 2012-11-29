module Levels
  module Audit
    class RootObserver

      def initialize(lazy_evaluator)
        @lazy_evaluator = lazy_evaluator
        @current_value = nil
      end

      def observe_group(user_observer)
        if @current_value
          observer = NestedGroupObserver.new(value_observer)
          @current_value.add_nested_group_observer(observer)
          observer
        else
          GroupObserver.new(value_observer, user_observer)
        end
      end

      def with_current_value(value)
        begin
          @current_value = value
          yield
        ensure
          @current_value = nil
        end
      end

    protected

      def value_observer
        ValueObserver.new(self, @lazy_evaluator)
      end
    end
  end
end


