require 'helper'

describe "acceptance: read toml" do

  def read_toml(level_name, toml_string)
    level = Levels::Level.new(level_name)
    input = Levels::Input::TOML.new(toml_string)
    input.read(level)
    level
  end

  let(:toml) {
    <<-TOML
[types]
string = "hello"
integer = 123
float = 1.5
boolean_true = true
boolean_false = false
array_of_string = ["a", "b", "c"]
array_of_integer = [1, 2, 3]
null = "TOML does not have a way to define NULL"
[group2]
message = "hello world"
    TOML
  }

  subject { read_toml("test", toml) }

  assert_sample_data_set
end

