require 'helper'

describe Config::Env::Load::Environment do

  let(:template) { Config::Env::Level.new("template") }
  let(:prefix)   { nil }
  let(:env_hash) { {} }

  subject { Config::Env::Load::Environment.new(template, prefix, env_hash) }

  let(:loaded) { subject.load }

  [nil, "MY_"].each do |prefix|
    describe "finding data in the environment with #{prefix || 'no'} prefix" do

      let(:prefix) { prefix }

      before do
        template.set_group(:sample, hello: "world")
        template.set_group(:settings, hello: "world")
      end

      it "finds variables that exist in the template" do
        env_hash["#{prefix}SAMPLE_HELLO"] = "universe"

        loaded.must_equal(
          sample: {
            hello: "universe"
          }
        )
      end

      it "does not find variables not in the template" do
        env_hash["#{prefix}SAMPLE_WORLD"] = "this"
        env_hash["#{prefix}OTHER_HELLO"] = "that"

        loaded.must_equal({})
      end

      it "does not find variables with another prefix" do
        env_hash["OTHER_SAMPLE_HELLO"] = "ok"

        loaded.must_equal({})
      end
    end
  end

  describe "typecasting data from the environment" do
    # TODO
  end
end
