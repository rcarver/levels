require 'helper'

describe "acceptance: write json" do

  let_standard_level

  subject { Levels.write_json(level) }

  it "converts to JSON" do
    subject.must_equal <<-JSON.chomp
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

