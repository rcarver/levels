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

      attr_reader :nested_group_observers

      def final?
        !!@final
      end

      def notify(observer)
        nested_group_observers.each do |ngo|
          ngo.notify_nested(observer)
        end
      end

      def raw
        value
      end

      def inspect
        value.inspect
      end
    end
  end
end

