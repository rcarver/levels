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
end

