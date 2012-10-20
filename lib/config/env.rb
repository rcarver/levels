require "json"

require "config/env/version"

require "config/env/method_missing"

require "config/env/event_handler"
require "config/env/group"
require "config/env/level"
require "config/env/merged"
require "config/env/merged_group"

require "config/env/input/json"
require "config/env/input/system"

require "config/env/output/json"

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
  end
end

