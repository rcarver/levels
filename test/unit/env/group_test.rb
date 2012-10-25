require 'helper'

describe Config::Env::Group do

  let(:hash) { {} }
  let(:value_transformer) { nil }

  subject { Config::Env::Group.new("fake level", :test, hash, value_transformer) }

  before do
    hash[:name] = "ok"
    hash[:value] = 123
    hash[:other] = nil
  end

  specify "#_group_name" do
    subject._group_name.must_equal :test
  end

  specify "#_level_name" do
    subject._level_name.must_equal "fake level"
  end

  specify "#to_s" do
    subject.to_s.must_equal "<Config::Env::Group test (\"fake level\")>"
  end

  it "allows hash access" do
    subject[:name].must_equal "ok"
    subject[:value].must_equal 123
    subject[:other].must_equal nil
  end

  it "allows dot access" do
    subject.name.must_equal "ok"
    subject.value.must_equal 123
    subject.other.must_equal nil
  end

  it "raises an error if you access a nonexistent key" do
    proc { subject[:foo] }.must_raise Config::Env::UnknownKey
    proc { subject.foo }.must_raise Config::Env::UnknownKey
  end

  it "allows the existence of a key to be tested" do
    subject.defined?(:name).must_equal true
    subject.defined?(:foo).must_equal false
    subject.name?.must_equal true
    subject.foo?.must_equal false
  end

  it "makes sure you don't call it wrong" do
    proc { subject.name("ok") }.must_raise ArgumentError
  end

  describe "initialized with string keys" do

    it "converts everything to symbols" do
      hash["string"] = 123
      subject.string.must_equal 123
      subject[:string].must_equal 123
    end
  end

  describe "initialized with a value transformer" do

    let(:value_transformer) {
      -> key, value { [key, value] }
    }

    it "returns the value via the transformer" do
      subject.name.must_equal [:name, "ok"]
      subject[:name].must_equal [:name, "ok"]
      subject["name"].must_equal [:name, "ok"]
    end
  end

  describe "#to_enum" do

    it "returns an Enumerator" do
      subject.to_enum.must_be_instance_of Enumerator
    end

    it "iterates over all keys and values" do
      result = subject.to_enum.map do |k, v|
        [k.to_sym, v]
      end
      expected = [
        [:name, "ok"],
        [:value, 123],
        [:other, nil]
      ]
      result.sort.must_equal expected.sort
    end
  end

  describe "#eql_hash?" do

    let(:expected) {
      {
        name: "ok",
        value: 123,
        "other" => nil
      }
    }

    it "is true if the hash matches the data" do
      subject.eql_hash?(expected).must_equal true
      subject.eql_hash?(a: 1).must_equal false
    end
  end
end

