module Levels
  class LazyEvaluator

    def initialize(level, event_handler = nil, key_formatter = nil)
      @level = level
      @event_handler = event_handler || Levels::NullEventHandler.new
      @key_formatter = key_formatter || Levels::System::KeyFormatter.new
    end

    def call(value)
      loop do
        case value
        #when /\$\{[A-Z_]+\}/
        when Proc
          #@event_handler.on_loopback do
            dsl = DSL.new(@level)
            value = dsl.instance_exec(&value)
          #end
        else
          return value
        end
      end
    end

    class DSL
      include Levels::MethodMissing
      # TODO: include Levels::Runtime

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
