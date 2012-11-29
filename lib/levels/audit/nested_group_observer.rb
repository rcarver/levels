module Levels
  module Audit
    class NestedGroupObserver

      def initialize(value_observer)
        @value_observer = value_observer
        @values = []
      end

      def observe_values(levels, group_key, value_key)
        values = @value_observer.observe_values(levels, group_key, value_key)
        @values << values
        values
      end

      def notify_nested(user_observer)
        @values.each { |v| user_observer.on_nested_values(v) }
        @values.clear
      end
    end
  end
end
