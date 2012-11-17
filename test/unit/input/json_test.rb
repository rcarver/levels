require 'helper'

describe Levels::Input::JSON do

  let(:json_string) {
    <<-STR
{
  "group1": {
    "key1": "string",
    "key2": 123
  },
  "group2": {
    "key": [1, 2, 3]
  }
}
    STR
  }

  subject { Levels::Input::JSON.new(json_string) }

  it "reads data from the JSON structure" do
    assert_input_equals_hash(
      group1: {
        key1: "string",
        key2: 123
      },
      group2: {
        key: [1, 2, 3]
      }
    )
  end
end
