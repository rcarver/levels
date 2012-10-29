require 'helper'

describe Levels::Output::System do

  let(:data) {
    {
      group1: {
        key: "hello",
      },
      group2: {
        key: "world"
      }
    }
  }

  subject { Levels::Output::System.new }

  def result
    subject.generate(data.to_enum)
  end

  it "converts to environment vars" do
    result.must_equal <<-STR.chomp
export GROUP1_KEY="hello"
export GROUP1_KEY_TYPE="string"
export GROUP2_KEY="world"
export GROUP2_KEY_TYPE="string"
    STR
  end
end


