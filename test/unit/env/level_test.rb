require 'helper'

describe Config::Env::Level do

  subject { Config::Env::Level.new("test") }

  specify "#_level_name" do
    subject._level_name.must_equal "test"
  end

  specify "#to_s" do
    subject.to_s.must_equal "<Config::Env::Level \"test\">"
  end

  it "allows groups to be defined and accessed" do
    subject.set_group(:test, key: 123)
    subject.test.must_be_instance_of Config::Env::Group
    subject[:test].must_be_instance_of Config::Env::Group
  end

  it "handls a string group name" do
    subject.set_group("test", key: 123)
    subject.test.must_be_instance_of Config::Env::Group
    subject[:test].must_be_instance_of Config::Env::Group
  end

  it "raises an error if you access an unknown group" do
    proc { subject.nothing }.must_raise Config::Env::UnknownGroup
    proc { subject[:nothing] }.must_raise Config::Env::UnknownGroup
  end

  it "allows the existence of a group to be tested" do
    subject.set_group(:test, key: 123)
    subject.defined?(:test).must_equal true
    subject.defined?(:foo).must_equal false
    subject.test?.must_equal true
    subject.foo?.must_equal false
  end

  it "does not allow a group to be redefined" do
    subject.set_group(:test, key: 123)
    proc { subject.set_group(:test, key: 123) }.must_raise Config::Env::DuplicateGroup
  end

  describe "#to_enum" do

    it "returns an Enumerator" do
      subject.to_enum.must_be_instance_of Enumerator
    end

    it "iterates over all groups" do
      subject.set_group(:test1, key: 123)
      subject.set_group(:test2, key: 123)
      result = subject.to_enum.map do |k, v|
        [k.to_sym, v.class]
      end
      expected = [
        [:test1, Enumerator],
        [:test2, Enumerator]
      ]
      result.sort.must_equal expected.sort
    end
  end

  describe "#eql_hash?" do

    let(:expected) {
      {
        test1: {
          key: 123
        },
        "test2" => {
          "key" => 123
        }
      }
    }

    before do
      subject.set_group(:test1, key: 123)
      subject.set_group(:test2, key: 123)
    end

    it "is true if the hash matches the data" do
      subject.eql_hash?(expected).must_equal true
      subject.eql_hash?(a: 1).must_equal false
    end
  end
end

