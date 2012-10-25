require 'helper'

describe Config::Env::KeyValues do

  let(:data) { nil }

  subject { Config::Env::KeyValues.new(data) }

  describe "in general" do

    let(:data) { { "a" => 1 } }

    describe "#[]" do

      it "handles string keys" do
        subject["a"].must_equal 1
      end

      it "handles symbol keys" do
        subject[:a].must_equal 1
      end

      it "returns nil when the key does not exist" do
        subject[:b].must_equal nil
      end
    end

    describe "#[]=" do

      it "handles string keys" do
        subject["a"] = 2
        subject[:a].must_equal 2
      end

      it "handles Symbol keys" do
        subject[:a] = 2
        subject[:a].must_equal 2
      end

      it "can add new keys" do
        subject[:b] = 1
        subject[:b].must_equal 1
      end
    end

    describe "#key?" do

      it "handles string keys" do
        subject.key?("a").must_equal true
      end

      it "handles symbol keys" do
        subject.key?(:a).must_equal true
      end

      it "returns false if the key does not exist" do
        subject.key?(:b).must_equal false
      end
    end

    specify "#inspect" do
      subject.inspect.must_equal "<Config::Env::KeyValues>"
    end

    specify "#to_s" do
      subject.to_s.must_equal subject.inspect
    end
  end

  describe "comparisons" do

    let(:a) { Config::Env::KeyValues.new(a: 1) }
    let(:b) { Config::Env::KeyValues.new(a: 1) }
    let(:c) { Config::Env::KeyValues.new(b: 1) }

    specify "equality" do
      (a == b).must_equal true
      (a == c).must_equal false
      (a == {a:1}).must_equal false
    end

    specify "hashing" do
      hash = {}
      hash[a] = true
      hash[a].must_equal true
      hash[b].must_equal true
      hash[c].must_equal nil
      hash[{a:1}].must_equal nil
    end
  end
end



