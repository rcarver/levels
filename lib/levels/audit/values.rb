module Levels
  module Audit
    # The Values is a set of possible values for a group+value key.
    class Values

      # Initialize a new Values.
      #
      # group_key - Levels::Key.
      # value_key - Levels::Key.
      # values    - Array of Levels::Audit::Value.
      #
      def initialize(group_key, value_key, values)
        @group_key = group_key
        @value_key = value_key
        @values = values
      end

      # Public: Returns a Levels::Key.
      attr_reader :group_key

      # Public: Returns a Levels::Key.
      attr_reader :value_key

      # Public: Returns the actual user-defined final value.
      def final_value
        @values.find { |v| v.final? }.value
      end

      include Enumerable

      def each(&block)
        @values.each(&block)
      end

      def empty?
        @values.empty?
      end

      def inspect
        "<Values #{group_key.inspect} #{value_key.inspect} #{@values.inspect}>"
      end
    end
  end
end
