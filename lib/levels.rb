require "json"
require "yaml"
require "open3"

require "levels/version"

require "levels/method_missing"
require "levels/runtime"

require "levels/audit"
require "levels/configuration"
require "levels/configured_group"
require "levels/event_handler"
require "levels/group"
require "levels/key"
require "levels/key_values"
require "levels/lazy_evaluator"
require "levels/level"
require "levels/setup"

require "levels/input/json"
require "levels/input/ruby"
require "levels/input/system"
require "levels/input/yaml"

require "levels/output/json"
require "levels/output/system"
require "levels/output/yaml"

require "levels/system/constants"
require "levels/system/key_formatter"
require "levels/system/key_generator"
require "levels/system/key_parser"

module Levels

  # Error thrown if a group is defined more than once.
  DuplicateGroup = Class.new(StandardError)

  # Error thrown when attempting to access a group that has not been defined.
  UnknownGroup = Class.new(StandardError)

  # Error thrown when attempting to read a key that has not been defined.
  UnknownKey = Class.new(StandardError)

  # Public: Begin a new setup. The setup is used to add one or more
  # levels, then merged into a configuration.
  #
  # Examples
  #
  #   setup = Levels.setup
  #   setup.add "Base", "file.rb"
  #   setup.add_system
  #   my_config = setup.merge
  #
  # Returns a Levels::Setup.
  def self.setup
    Levels::Setup.new
  end

  # Public: Get a merged configuration by using the setup.
  #
  # Examples
  #
  #   my_config = Levels.merge do |setup|
  #     setup.add "Base", "file.rb"
  #     setup.add_system
  #   end
  #
  # Returns a Levels::Configuration.
  def self.merge
    setup = self.setup
    yield setup if block_given?
    setup.merge
  end
end

