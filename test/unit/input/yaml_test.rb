require 'helper'

describe Levels::Input::YAML do

  let(:yaml_string) {
    <<-STR
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
  }

  subject { Levels::Input::YAML.new(yaml_string) }

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

