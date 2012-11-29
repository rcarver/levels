module Levels
  # This is the interface for capturing what happens when a key is
  # read from a merged group.
  module EventHandler

    def on_values(values)
    end

    def on_nested_values(values)
    end
  end

  # A null implementation.
  class NullEventHandler
    include EventHandler
  end

  module Colorizer

    RESET =    "\033[0m"
    FOREGROUND = {
      black:   "\033[30m",
      red:     "\033[31m",
      green:   "\033[32m",
      brown:   "\033[33m",
      blue:    "\033[34m",
      magenta: "\033[35m",
      cyan:    "\033[36m",
      white:   "\033[37m"
    }

    def foreground_color(name, str)
      code = FOREGROUND[name] or raise ArgumentError, "Unknown color #{name.inspect}"
      "#{code}#{str}#{RESET}"
    end
  end

  class CliEventHandler
    include Colorizer

    def initialize(stream, color = false)
      @stream = stream
      @color = color
      @indent = 0
    end

    def on_values(values)
      write :white, "> #{values.group_key}.#{values.value_key}"
      values.each do |value|
        value.notify(self)
        if value.final?
          write :green, " + #{value.inspect} from #{value.level_name}"
        else
          write :red, " - #{value.inspect} from #{value.level_name}"
        end
      end
    end

    def on_nested_values(values)
      indent do
        on_values(values)
      end
    end

  protected

    def indent
      begin
        @indent += 1
        yield
      ensure
        @indent -= 1
      end
    end

    def write(color, str)
      prefix = "  " * @indent
      str = foreground_color(color, str) if @color
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
