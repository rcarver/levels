require 'helper'

describe Levels::System::KeyFormatter do

  let(:prefix) { nil }
  let(:joiner) { nil }

  subject { Levels::System::KeyFormatter.new(prefix, joiner) }

  describe "without a prefix" do

    it "creates a key" do
      subject.create(:a, "b", "C").must_equal "A_B_C"
    end
  end

  describe "with a prefix" do

    let(:prefix) { "PREFIX_" }

    it "creates a key" do
      subject.create(:a, "b", "C").must_equal "PREFIX_A_B_C"
    end
  end

  describe "with a custom joiner" do

    let(:joiner) { "-" }

    it "changes the joiner" do
      subject.create(:a, "b", "C").must_equal "A-B-C"
    end

    describe "with a prefix" do

      let(:prefix) { "PREFIX_" }

      it "does not affect the prefix" do
        subject.create(:a, "b", "C").must_equal "PREFIX_A-B-C"
      end
    end
  end
end
