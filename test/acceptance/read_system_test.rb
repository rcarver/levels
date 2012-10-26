require 'helper'

describe "acceptance: read system" do

  describe "using typecast information" do

    let(:template) {
      level = Config::Env::Level.new("template level")
      level.set_group(:types,
        string: nil,
        integer: nil,
        float: nil,
        boolean_true: nil,
        boolean_false: nil,
        array_of_string: nil,
        array_of_integer: nil,
        null: nil
      )
      level.set_group(:group2,
        message: nil
      )
      level
    }

    let(:env) {
      {
        "TYPES_STRING" => "hello",
        "TYPES_INTEGER" => "123",
        "TYPES_INTEGER_TYPE" => "integer",
        "TYPES_FLOAT" => "1.5",
        "TYPES_FLOAT_TYPE" => "float",
        "TYPES_BOOLEAN_TRUE" => "true",
        "TYPES_BOOLEAN_TRUE_TYPE" => "boolean",
        "TYPES_BOOLEAN_FALSE" => "false",
        "TYPES_BOOLEAN_FALSE_TYPE" => "boolean",
        "TYPES_ARRAY_OF_STRING" => "a:b:c",
        "TYPES_ARRAY_OF_STRING_TYPE" => "array",
        "TYPES_ARRAY_OF_INTEGER" => "1:2:3",
        "TYPES_ARRAY_OF_INTEGER_TYPE" => "array",
        "TYPES_ARRAY_OF_INTEGER_TYPE_TYPE" => "integer",
        "TYPES_NULL" => "",
        "GROUP2_MESSAGE" => "hello world"
      }
    }

    subject { Config::Env.read_system("the system", template.to_enum, nil, env) }

    assert_sample_data_set
  end

  describe "using the template's types" do

    let(:template) {
      level = Config::Env::Level.new("template level")
      level.set_group(:types,
        string: "!hello",
        integer: 0123,
        float: 1.55,
        boolean_true: false,
        boolean_false: true,
        array_of_string: ["a", "a", "a"],
        array_of_integer: [1, 1, 1],
        null: 999
      )
      level.set_group(:group2,
        message: "hello there"
      )
      level
    }

    let(:env) {
      {
        "TYPES_STRING" => "hello",
        "TYPES_INTEGER" => "123",
        "TYPES_FLOAT" => "1.5",
        "TYPES_BOOLEAN_TRUE" => "true",
        "TYPES_BOOLEAN_FALSE" => "false",
        "TYPES_ARRAY_OF_STRING" => "a:b:c",
        "TYPES_ARRAY_OF_INTEGER" => "1:2:3",
        "TYPES_NULL" => "",
        "GROUP2_MESSAGE" => "hello world"
      }
    }

    subject { Config::Env.read_system("the system", template.to_enum, nil, env) }

    assert_sample_data_set
  end

  describe "using a prefix" do

    let(:template) {
      level = Config::Env::Level.new("template level")
      level.set_group(:group,
        message: "hello there"
      )
      level
    }

    let(:env) {
      {
        "PREFIX_GROUP_MESSAGE" => "hello world"
      }
    }

    subject { Config::Env.read_system("the system", template.to_enum, "PREFIX_", env) }

    it "finds values" do
      subject.group.message.must_equal "hello world"
    end
  end
end

