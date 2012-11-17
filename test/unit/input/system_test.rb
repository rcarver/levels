require 'helper'

describe Levels::Input::System do

  let(:template) { {} }
  let(:key_formatter) { nil }
  let(:env_hash) { {} }

  subject { Levels::Input::System.new(template.to_enum, key_formatter, env_hash) }

  [nil, "MY_"].each do |prefix|
    describe "finding data in the System with #{prefix || 'no'} prefix" do

      let(:key_formatter) { Levels::System::KeyFormatter.new(prefix) }

      before do
        template[:sample] = { hello: "world" }.to_enum
        template[:settings] = { hello: "world" }.to_enum
      end

      it "finds variables that exist in the template" do
        env_hash["#{prefix}SAMPLE_HELLO"] = "universe"

        assert_input_equals_hash(
          sample: {
            hello: "universe"
          }
        )
      end

      it "does not find variables not in the template" do
        env_hash["#{prefix}SAMPLE_WORLD"] = "this"
        env_hash["#{prefix}OTHER_HELLO"] = "that"

        assert_input_equals_hash({})
      end

      it "does not find variables with another prefix" do
        env_hash["OTHER_SAMPLE_HELLO"] = "ok"

        assert_input_equals_hash({})
      end
    end
  end

  describe "typecasting data from the system" do

      it "converts data to the right type" do
        env_hash["SAMPLE_NUMBER"] = "123"
        env_hash["SAMPLE_NUMBER_TYPE"] = "integer"

        assert_input_equals_hash(
          sample: {
            number: 123
          }
        )
      end
  end
end
