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

  def assert_level_equals_hash(hash)
    level = Levels::Level.new("Test")
    subject.read(level)
    level.eql_hash?(hash).must_equal true
  end

  it "reads data from the JSON structure" do
    assert_level_equals_hash(
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