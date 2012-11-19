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

      # The Ruby syntax DSL. This syntax aims to be very readable and writable.
      # A stateful syntax and no trailing commas allows values to be easily
      # moved around without excess text editing.
      #
      # Examples
      #
      #     group :webserver
      #       set hostname: "localhost"
      #     group :task_queue
      #       set workers: 1
      #       set queues: -> { ["high", "low", webserver.hostname] }
      #
      class DSL
        include Levels::Runtime

        def initialize(level)
          @level = level
        end

        # Public: Start a group.
        #
        # name - Symbol or String name of the group.
        #
        # Returns nothing.
        # Raises a RuntimeError if the group has already been defined.
        def group(name)
          close_current_group
          if @level.defined?(name)
            raise RuntimeError, "Group has already been created: #{name.inspect}"
          end
          @group = name
          @hash = {}
          nil
        end

        # Public: Set a key/value pair in the current group.
        #
        # Arguments
        #
        # hash  - Hash of key/value pairs. The keys may be a Symbol or String.
        #
        # key   - Symbol or String key.
        # value - Any value.
        #
        # Examples
        #
        #     # Ruby 1.9 Hash.
        #     set key: "value"
        #
        #     # Ruby 1.9 Hash.
        #     set :key => "value"
        #
        #     # Key can be a String.
        #     set "key" => "value"
        #
        #     # Multiple key/values.
        #     set :key => "value", :more => "values"
        #
        #     # Key, value.
        #     set :key, "value"
        #
        # Returns nothing.
        # Raises SyntaxError if no current group is defined.
        # Raises ArgumentError if other forms of arguments are given
        # Raises RuntimeError if a key has already been set.
        def set(*args)
          raise SyntaxError, "No group is defined" if @hash.nil?
          case
          when args.size == 1 && Hash === args.first
            hash = args.first
          when args.size == 2 && !(args.any? { |a| Hash === a })
            hash = { args.first => args.last }
          else
            raise ArgumentError, "Set must be given a Hash or two arguments. Got #{args.inspect}"
          end
          key_values = Levels::KeyValues.new(@hash)
          hash.keys.each do |key|
            if key_values.key?(key)
              raise RuntimeError, "Key has already been set: #{key.inspect}"
            end
          end
          @hash.update(hash)
          nil
        end

        def close_current_group
          @level.set_group(@group, @hash) if @group
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

