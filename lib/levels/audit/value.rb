module Levels
  module Audit
    class Value

      def initialize(level_name, final)
        @level_name = level_name
        @final = final
        @nested_group_observers = []
        @value = yield self
      end

      attr_reader :level_name
      attr_reader :value

      alias raw value

      def final?
        !!@final
      end

      def inspect
        value.inspect
      end

      def add_nested_group_observer(nested_group_observer)
        @nested_group_observers << nested_group_observer
      end

      def notify(observer)
        @nested_group_observers.each do |ngo|
          ngo.notify_nested(observer)
        end
      end

    end
  end
end

