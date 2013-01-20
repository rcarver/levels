require 'helper'

describe "acceptance: read json" do

  def read_json(level_name, json_string)
    level = Levels::Level.new(level_name)
    input = Levels::Input::JSON.new(json_string)
    input.read(level)
    level
  end

  let(:json) {
    <<-JSON
{
  "types": {
    "string": "hello",
    "integer": 123,
    "float": 1.5,
    "boolean_true": true,
    "boolean_false": false,
    "array_of_string": ["a", "b", "c"],
    "array_of_integer": [1, 2, 3],
    "null": null
  },
  "group2": {
    "message": "hello world"
  }
}
    JSON
  }

  subject { read_json("test", json) }

  assert_sample_data_set
end
