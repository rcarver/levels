require 'helper'

describe "acceptance: write yaml" do

  let_standard_level

  subject { Levels.write_yaml(level) }

  it "converts to YAML" do
    subject.must_equal <<-JSON.sub(/'null':$/, '\0 ') # Handle trailing space for null.
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
