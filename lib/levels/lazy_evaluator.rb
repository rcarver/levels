module Levels
  class LazyEvaluator

    def initialize(level, key_formatter = nil)
      @level = level
      @key_formatter = key_formatter || Levels::System::KeyFormatter.new
    end

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

    class DSL
      include Levels::MethodMissing
      include Levels::Runtime

      def initialize(level)
        @level = level
      end

      def defined?(key)
        @level.defined?(key)
      end

      def [](key)
        @level[key]
      end
    end
  end
end
