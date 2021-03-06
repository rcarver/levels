require 'helper'

describe "acceptance: write system" do

  def write_system(level, prefix = nil)
    key_formatter = Levels::System::KeyFormatter.new(prefix)
    output = Levels::Output::System.new(key_formatter)
    output.generate(level.to_enum)
  end

  it "converts to ENV variables" do
    output = write_system(standard_data_types_level)
    output.must_equal <<-ENV.chomp
export TYPES_STRING="hello"
export TYPES_STRING_TYPE="string"
export TYPES_INTEGER="123"
export TYPES_INTEGER_TYPE="integer"
export TYPES_FLOAT="1.5"
export TYPES_FLOAT_TYPE="float"
export TYPES_BOOLEAN_TRUE="true"
export TYPES_BOOLEAN_TRUE_TYPE="boolean"
export TYPES_BOOLEAN_FALSE="false"
export TYPES_BOOLEAN_FALSE_TYPE="boolean"
export TYPES_ARRAY_OF_STRING="a:b:c"
export TYPES_ARRAY_OF_STRING_TYPE="array"
export TYPES_ARRAY_OF_STRING_DELIMITER=":"
export TYPES_ARRAY_OF_STRING_TYPE_TYPE="string"
export TYPES_ARRAY_OF_INTEGER="1:2:3"
export TYPES_ARRAY_OF_INTEGER_TYPE="array"
export TYPES_ARRAY_OF_INTEGER_DELIMITER=":"
export TYPES_ARRAY_OF_INTEGER_TYPE_TYPE="integer"
export TYPES_NULL=""
export TYPES_NULL_TYPE="string"
export GROUP2_MESSAGE="hello world"
export GROUP2_MESSAGE_TYPE="string"
    ENV
  end

  it "converts to ENV variables with a prefix" do
    output = write_system(standard_data_types_level, "FOO_")
    output.must_equal <<-ENV.chomp
export FOO_TYPES_STRING="hello"
export FOO_TYPES_STRING_TYPE="string"
export FOO_TYPES_INTEGER="123"
export FOO_TYPES_INTEGER_TYPE="integer"
export FOO_TYPES_FLOAT="1.5"
export FOO_TYPES_FLOAT_TYPE="float"
export FOO_TYPES_BOOLEAN_TRUE="true"
export FOO_TYPES_BOOLEAN_TRUE_TYPE="boolean"
export FOO_TYPES_BOOLEAN_FALSE="false"
export FOO_TYPES_BOOLEAN_FALSE_TYPE="boolean"
export FOO_TYPES_ARRAY_OF_STRING="a:b:c"
export FOO_TYPES_ARRAY_OF_STRING_TYPE="array"
export FOO_TYPES_ARRAY_OF_STRING_DELIMITER=":"
export FOO_TYPES_ARRAY_OF_STRING_TYPE_TYPE="string"
export FOO_TYPES_ARRAY_OF_INTEGER="1:2:3"
export FOO_TYPES_ARRAY_OF_INTEGER_TYPE="array"
export FOO_TYPES_ARRAY_OF_INTEGER_DELIMITER=":"
export FOO_TYPES_ARRAY_OF_INTEGER_TYPE_TYPE="integer"
export FOO_TYPES_NULL=""
export FOO_TYPES_NULL_TYPE="string"
export FOO_GROUP2_MESSAGE="hello world"
export FOO_GROUP2_MESSAGE_TYPE="string"
    ENV
  end
end


