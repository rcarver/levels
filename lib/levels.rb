require "json"
require "yaml"

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

  # Internal: Create a merge from one or more env levels.
  def self.merge(*levels)
    Merged.new(levels)
  end

  def self.read_ruby(level_name, ruby_string, file, line = 1)
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

