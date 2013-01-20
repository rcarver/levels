require 'helper'

describe "acceptance: write json" do

  def write_json(level)
    output = Levels::Output::JSON.new
    output.generate(level.to_enum)
  end

  it "converts to JSON" do
    output = write_json(standard_data_types_level)
    output.must_equal <<-JSON.chomp
{
  "types": {
    "string": "hello",
    "integer": 123,
    "float": 1.5,
    "boolean_true": true,
    "boolean_false": false,
    "array_of_string": [
      "a",
      "b",
      "c"
    ],
    "array_of_integer": [
      1,
      2,
      3
    ],
    "null": null
  },
  "group2": {
    "message": "hello world"
  }
}
    JSON
  end
end

