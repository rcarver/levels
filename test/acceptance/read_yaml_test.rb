require 'helper'

describe "acceptance: read yaml" do

  def read_yaml(level_name, yaml_string)
    level = Levels::Level.new(level_name)
    input = Levels::Input::YAML.new(yaml_string)
    input.read(level)
    level
  end

  let(:yaml) {
    <<-YAML
types:
  string: hello
  integer: 123
  float: 1.5
  boolean_true: true
  boolean_false: false
  array_of_string:
    - a
    - b
    - c
  array_of_integer:
    - 1
    - 2
    - 3
  "null": null
group2:
  message: hello world
    YAML
  }

  subject { read_yaml("test", yaml) }

  assert_sample_data_set
end

