module Levels
  module Audit
    class Values

      def initialize(group_key, value_key, values)
        @group_key = group_key
        @value_key = value_key
        @values = values
      end

      attr_reader :group_key
      attr_reader :value_key

      def final_value
        @values.find { |v| v.final? }.value
      end

      include Enumerable

      def each(&block)
        @values.each(&block)
      end

      def inspect
        "<Values #{group_key.inspect} #{value_key.inspect} #{@values.inspect}>"
      end
    end
  end
end
