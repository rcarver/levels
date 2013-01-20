require 'helper'

describe "acceptance: write yaml" do

  def write_yaml(level)
    output = Levels::Output::YAML.new
    output.generate(level.to_enum)
  end

  it "converts to YAML" do
    output = write_yaml(standard_data_types_level)
    output.must_equal <<-JSON.sub(/'null':$/, '\0 ') # Handle trailing space for null.
---
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
  'null':
group2:
  message: hello world
    JSON
  end
end
