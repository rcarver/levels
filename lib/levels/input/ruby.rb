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
        dsl.close_current_group
      end

      class DSL

        def initialize(level)
          @level = level
        end

        def group(name)
          close_current_group
          @group = name
          @hash = {}
        end

        def set(hash)
          return if @hash.nil?
          @hash.update(hash)
        end

        def close_current_group
          if @group && @hash
            @level.set_group(@group, @hash)
          end
          @group = nil
          @hash = nil
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

