module Levels
  module Input
    # This input provides a DSL for writing levels in ruby.
    class Ruby

      def initialize(ruby_string, file, line = 1)
        @ruby_string = ruby_string
        @file = file
        @line = line
      end

      def read(level)
        dsl = DSL.new(level)
        dsl.instance_eval(@ruby_string, @file, @line)
      end

      class DSL

        def initialize(level)
          @level = level
        end

        # Public: Set configuration variables.
        #
        # name - Symbol name of the group.
        # hash - Hash of Symbol keys and any values.
        #
        # Returns nothing.
        def set(name, hash)
          @level.set_group(name, hash)
        end

        def to_s
          "<Levels>"
        end

        def inspect
          "<Levels>"
        end
      end
    end
  end
end

