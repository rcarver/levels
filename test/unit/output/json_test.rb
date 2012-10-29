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

  let(:json_opts) { nil }

  subject { Config::Env::Output::JSON.new(json_opts) }

  def result
    subject.generate(data.to_enum)
  end

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


  describe "initialized with json opts" do

    let(:json_opts) { {} }

    it "changes the formatting" do
      result.must_equal <<-STR.chomp
{"group1":{"key1":"string","key2":123},"group2":{"key":[1,2,3]}}
      STR
    end
  end
end

