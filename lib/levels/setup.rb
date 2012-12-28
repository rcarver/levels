module Levels
  class Setup

    # Internal: Initialize a new Levels::Setup.
    def initialize
      @inputs = []
    end

    # Public: Add a level of configuration.
    #
    # name   - String name of the level.
    # source - String file path or code to parse.
    #
    # Returns nothing.
    def add(name, source)
      level = -> { Levels::Level.new(name) }
      input = Input.new(source)
      @inputs << [level, input]
    end

    # Public: Add the system environment as a level of configuration.
    #
    # prefix   - String the prefix for environment variables (default
    #            none).
    # name     - String the name of the level (default: "System
    #            Environment").
    # env_hash - Hash of environment variables (default: ENV).
    #
    # Returns nothing.
    def add_system(prefix = nil, name = nil, env_hash = ENV)
      key_formatter = Levels::System::KeyFormatter.new(prefix)
      level = -> { Levels::Level.new(name || "System Environment") }
      input = -> template { Levels::Input::System.new(template, key_formatter, env_hash) }
      @inputs << [level, input]
    end

    # Public: Parse all inputs sources and get a merged configuration.
    #
    # Returns a Levels::Merged.
    def merge
      levels = []
      @inputs.each do |level_proc, input|
        level = level_proc.call
        case input
        when Proc
          template = Levels::Merged.new(levels)
          input = input.call(template.to_enum)
          input.read(level)
        else
          input.read(level)
        end
        levels << level
      end
      Levels::Merged.new(levels)
    end

    # This class transforms a String into a level data.
    class Input

      def initialize(source)
        @source = source
      end

      # Read the input into a Level.
      def read(level)
        input.read(level)
      end

      # Returns a Levels::Input.
      # Raises an ArgumentError if the format couldn't be determined.
      def input
        format, source, *args = identify
        case format
        when :ruby then Levels::Input::Ruby.new(source, *args)
        when :json then Levels::Input::JSON.new(source)
        when :yaml then Levels::Input::YAML.new(source)
        else raise ArgumentError, "Could not identify the format"
        end
      end

      # Determine the format of the source and read it from disk if
      # it's a file.
      def identify
        pn = Pathname.new(@source)
        if pn.exist?
          case pn.extname
          when ".rb"           then [:ruby, pn.read, pn.to_s, 1]
          when ".json"         then [:json, pn.read]
          when ".yaml", ".yml" then [:yaml, pn.read]
          end
        else
          case @source
          when /\A\w*{/     then [:json, @source]
          when /\A---$/     then [:yaml, @source]
          when /\A\w*group/ then [:ruby, @source, "Code from String", 1]
          end
        end
      end
    end
  end
end
