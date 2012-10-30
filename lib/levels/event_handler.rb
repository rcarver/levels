module Levels
  # This is the interface for capturing what happens when a key is
  # read from a merged group.
  module EventHandler

    # Public: Receive notification that a key was read.
    #
    # group_name - Symbol the name of the group.
    # key        - Symbol the name of the key.
    # levels     - Array of [level_name, value] for each potential
    #              level. The last item is the actual level/value used.
    #
    # Returns nothing.
    def on_read_from_merged_group(group_name, key, levels)
    end
  end

  # A null implementation.
  class NullEventHandler
    include EventHandler
  end

  class CliEventHandler

    def initialize(stream)
      @stream = stream
    end

    def on_read_from_merged_group(group_name, key, levels)
      final_level_name, final_value = levels.last

      if levels.size == 1
        @stream.puts "Read #{group_name}.#{key} => #{final_value.inspect} from #{final_level_name}"
      else
        skipped_levels = levels[0..-2]

        @stream.puts "Read #{group_name}.#{key}"
        skipped_levels.each do |level_name, value|
          @stream.puts "  Skip #{value.inspect} from #{level_name}"
        end
        @stream.puts "  Use  #{final_value.inspect} from #{final_level_name}"
      end
    end
  end

  # A temporary implementation that will be moved back to config to
  # restore its original behavior.
  class ConfigCoreEventHandler

    def initialize(log)
      @log = log
      @base_color = :magenta
      @alt_color  = :cyan
    end

    def on_read_from_merged_group(group_name, key, levels)
      final_level_name, final_value = levels.last

      if levels.size == 1
        @log << @log.colorize("Read #{group_name}.#{key} => #{final_value.inspect} from #{final_level_name}", @base_color)
      else
        skipped_levels = levels[0..-2]

        @log << @log.colorize("Read #{group_name}.#{key}", @base_color)
        @log.indent do
          skipped_levels.each do |level_name, value|
            @log << @log.colorize("Skip #{value.inspect} from #{level_name}", @alt_color)
          end
          @log << @log.colorize("Use  #{final_value.inspect} from #{final_level_name}", @base_color)
        end
      end
    end
  end
end
