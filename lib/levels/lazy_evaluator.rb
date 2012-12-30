module Levels
  # Whenever a value is read, it's interpreted by the LazyEvaluator. This class
  # implements all of the interpolation rules.
  class LazyEvaluator

    # Internal: Initialize a new LazyEvaluator.
    #
    # level         - Levels::Level or equivalent, used to find referenced
    #                 groups and keys.
    # key_formatter - Levels::System::KeyFormatter.
    #
    def initialize(level, key_formatter = nil)
      @level = level
      @key_formatter = key_formatter || Levels::System::KeyFormatter.new
    end

    # Internal: Interpret the value.
    def call(value)
      loop do
        case value
        #when /\$\{[A-Z_]+\}/
        when Proc
          dsl = DSL.new(@level)
          value = dsl.instance_exec(&value)
        when Array
          return value.map { |v| call(v) }
        else
          return value
        end
      end
    end

    # This is the class that evaluations Proc values. When you define a value
    # as a Proc, it's evaluation in the context of an instance of this class.
    class DSL
      include Levels::MethodMissing
      include Levels::Runtime

      def initialize(level)
        @level = level
      end

      # Public: Determine if a group exists.
      def defined?(group_key)
        @level.defined?(group_key)
      end

      # Public: Retrieve a group.
      def [](group_key)
        @level[group_key]
      end
    end
  end
end
