module Levels
  # This is the interface for capturing what happens when a key is
  # read from a merged group.
  module EventHandler

    def on_read(group_name, key)
    end

    def on_evaluate(group_name, key, level_name)
      yield
    end

    def on_values(group_name, key, levels)
    end
  end

  # A null implementation.
  class NullEventHandler
    include EventHandler
  end

  class CliEventHandler

    def initialize(stream)
      @stream = stream
      @indent = 0
    end

    def on_read(group_name, key)
      write "> #{group_name}.#{key}"
    end

    def on_evaluate(group_name, key, level_name)
      begin
        @indent += 1
        yield
      ensure
        @indent -= 1
      end
    end

    def on_values(group_name, key, levels)
      final_level_name, final_value = levels.last
      skipped_levels = levels[0..-2]

      skipped_levels.each do |level_name, value|
        write " - #{value.inspect} from #{level_name}"
      end

      write " + #{final_value.inspect} from #{final_level_name}"
    end

  protected

    def write(str)
      prefix = "  " * @indent
      @stream.puts prefix + str
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
