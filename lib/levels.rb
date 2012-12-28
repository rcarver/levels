require "json"
require "yaml"
require "open3"

require "levels/version"

require "levels/method_missing"
require "levels/runtime"

require "levels/audit"
require "levels/event_handler"
require "levels/group"
require "levels/key"
require "levels/key_values"
require "levels/lazy_evaluator"
require "levels/level"
require "levels/merged"
require "levels/merged_group"
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
  # levels, then get a merged configuration.
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
  # Returns a Levels::Merged.
  def self.merge
    setup = self.setup
    yield setup if block_given?
    setup.merge
  end

  def self.read_ruby(level_name, ruby_string, file = 'Ruby String', line = 1)
    level = Levels::Level.new(level_name)
    input = Levels::Input::Ruby.new(ruby_string, file, line)
    input.read(level)
    level
  end

  def self.read_json(level_name, json_string)
    level = Levels::Level.new(level_name)
    input = Levels::Input::JSON.new(json_string)
    input.read(level)
    level
  end

  def self.read_yaml(level_name, yaml_string)
    level = Levels::Level.new(level_name)
    input = Levels::Input::YAML.new(yaml_string)
    input.read(level)
    level
  end

  def self.read_system(level_name, template, prefix, env_hash = ENV)
    key_formatter = Levels::System::KeyFormatter.new(prefix)
    level = Levels::Level.new(level_name)
    input = Levels::Input::System.new(template, key_formatter, env_hash)
    input.read(level)
    level
  end

  def self.write_json(level, json_opts = nil)
    output = Levels::Output::JSON.new(json_opts)
    output.generate(level.to_enum)
  end

  def self.write_yaml(level)
    output = Levels::Output::YAML.new
    output.generate(level.to_enum)
  end

  def self.write_system(level, prefix = nil)
    key_formatter = Levels::System::KeyFormatter.new(prefix)
    output = Levels::Output::System.new(key_formatter)
    output.generate(level.to_enum)
  end
end

