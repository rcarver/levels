require 'helper'

describe Config::Env::Input::System do

  let(:template) { {} }
  let(:prefix)   { nil }
  let(:env_hash) { {} }

  subject { Config::Env::Input::System.new(template.to_enum, prefix, env_hash) }

  let(:read) { subject.read }

  [nil, "MY_"].each do |prefix|
    describe "finding data in the System with #{prefix || 'no'} prefix" do

      let(:prefix) { prefix }

      before do
        template[:sample] = { hello: "world" }.to_enum
        template[:settings] = { hello: "world" }.to_enum
      end

      it "finds variables that exist in the template" do
        env_hash["#{prefix}SAMPLE_HELLO"] = "universe"

        read.must_equal(
          sample: {
            hello: "universe"
          }
        )
      end

      it "does not find variables not in the template" do
        env_hash["#{prefix}SAMPLE_WORLD"] = "this"
        env_hash["#{prefix}OTHER_HELLO"] = "that"

        read.must_equal({})
      end

      it "does not find variables with another prefix" do
        env_hash["OTHER_SAMPLE_HELLO"] = "ok"

        read.must_equal({})
      end
    end
  end

  describe "typecasting data from the system" do
    # TODO
  end
end
