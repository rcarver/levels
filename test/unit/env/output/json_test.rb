require 'helper'

describe Config::Env::Output::JSON do

  let(:data) {
    {
      group1: {
        key1: "string",
        key2: 123
      },
      group2: {
        key: [1, 2, 3]
      }
    }
  }

  subject { Config::Env::Output::JSON.new(data.to_enum) }

  let(:result) { subject.result }

  it "converts to JSON" do
    result.must_equal <<-STR.chomp
{
  "group1": {
    "key1": "string",
    "key2": 123
  },
  "group2": {
    "key": [
      1,
      2,
      3
    ]
  }
}
    STR
  end

  it "allows the JSON format to be altered" do
    subject.json_opts[:indent] = ""
  end

  it "allows the JSON format to be replaced" do
    subject.json_opts = {}
    result.must_equal <<-STR.chomp
{"group1":{"key1":"string","key2":123},"group2":{"key":[1,2,3]}}
    STR
  end

end

