require 'helper'

describe Config::Env::System::KeyGenerator do

  subject { Config::Env::System::KeyGenerator.new }

  it "generates key/values for the data and typecasting" do
    enum = [
      [:group, :key1, "string"],
      [:group, :key2, 123]
    ].to_enum
    keys = subject.generate(enum)
    keys.must_equal(
      "GROUP_KEY1" => "string",
      "GROUP_KEY1_TYPE" => "string",
      "GROUP_KEY2" => "123",
      "GROUP_KEY2_TYPE" => "integer"
    )
  end
end

