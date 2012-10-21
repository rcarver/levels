require 'helper'

describe Config::Env::Output::System do

  let(:data) {
    {
      group1: {
        key1: "string",
        key2: 123
      },
      #group2: {
        #key: [1, 2, 3]
      #}
    }
  }

  let(:prefix) { nil }

  subject { Config::Env::Output::System.new(prefix) }

  def result
    subject.generate(data.to_enum)
  end

  it "converts to environment vars" do
    result.must_equal <<-STR.chomp
export GROUP1_KEY1="string"
export GROUP1_KEY2="123"
    STR
  end

  describe "initialized with a prefix" do

    let(:prefix) { "PFX_" }

    it "uses the prefix" do
      result.must_equal <<-STR.chomp
export PFX_GROUP1_KEY1="string"
export PFX_GROUP1_KEY2="123"
      STR
    end
  end
end


