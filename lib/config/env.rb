require "json"

require "config/env/version"

require "config/env/method_missing"

require "config/env/event_handler"
require "config/env/group"
require "config/env/key"
require "config/env/key_values"
require "config/env/level"
require "config/env/merged"
require "config/env/merged_group"
require "config/env/system_typecaster"

require "config/env/input/json"
require "config/env/input/system"

require "config/env/output/json"
require "config/env/output/system"

module Config
  # The Config::Env is a collection key/value pairs organized into groups.
  # Each group should define a single resource to be made available.
  module Env

    # Error thrown if a group is defined more than once.
    DuplicateGroup = Class.new(StandardError)

    # Error thrown when attempting to access a group that has not been defined.
    UnknownGroup = Class.new(StandardError)

    # Error thrown when attempting to read a key that has not been defined.
    UnknownKey = Class.new(StandardError)

    # Internal: Shorthand for creating an env level.
    def self.new(name = nil)
      Level.new(name || "[no name]")
    end

    # Internal: Create a merge from one or more env levels.
    def self.merge(*levels)
      Merged.new(levels)
    end

    def self.event_handler=(event_handler)
      @event_handler = event_handler
    end

    def self.event_handler
      @event_handler || Config::Env::NullEventHandler.new
    end

    def self.read_json(level_name, json_string)
      level = Config::Env::Level.new(level_name)
      input = Config::Env::Input::JSON.new(json_string)
      input.read(level)
      level
    end

    def self.read_system(level_name, template, prefix, env_hash = ENV)
      key_formatter = Config::Env::SystemTypecaster::SystemKeyFormatter.new(prefix)
      system_typecaster = Config::Env::SystemTypecaster.new(key_formatter)
      level = Config::Env::Level.new(level_name)
      input = Config::Env::Input::System.new(template, system_typecaster, env_hash)
      input.read(level)
      level
    end

    def self.write_json(level, json_opts = nil)
      output = Config::Env::Output::JSON.new(json_opts)
      output.generate(level.to_enum)
    end

    def self.write_system(level, prefix = nil)
      key_formatter = Config::Env::SystemTypecaster::SystemKeyFormatter.new(prefix)
      system_typecaster = Config::Env::SystemTypecaster.new(key_formatter)
      output = Config::Env::Output::System.new(system_typecaster)
      output.generate(level.to_enum)
    end
  end
end

