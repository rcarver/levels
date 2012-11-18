require 'helper'

describe Levels::Output::YAML do

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

  subject { Levels::Output::YAML.new }

  def result
    subject.generate(data.to_enum)
  end

  it "converts to YAML" do
    result.must_equal <<-STR
---
group1:
  key1: string
  key2: 123
group2:
  key:
  - 1
  - 2
  - 3
    STR
  end
end


