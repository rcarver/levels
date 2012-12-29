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

      # Public: Returns the Levels::Audit::Value marked final.
      def final
        @values.find { |v| v.final? }
      end

      # Public: Returns the actual user-defined final value.
      def final_value
        @values.find { |v| v.final? }.value
      end

      include Enumerable

      # Public: Iterate over all potential values.
      def each(&block)
        @values.each(&block)
      end

      # Public: Returns true if there are no potential values.
      def empty?
        @values.empty?
      end

      # Public: Returns true if there is only a final value.
      def only_final?
        size == 1 && final
      end

      # Public: Returns true if any of the values are recursive.
      def recursive?
        @values.any? { |v| v.recursive? }
      end

      # Public: Returns the number of potential values.
      def size
        @values.size
      end

      def inspect
        "<Values #{group_key.inspect} #{value_key.inspect} #{@values.inspect}>"
      end
    end
  end
end
