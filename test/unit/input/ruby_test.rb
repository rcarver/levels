require 'helper'

describe Levels::Input::Ruby do

  let(:level) { Levels::Level.new("Ruby") }

  subject { Levels::Input::Ruby.new(ruby_string, "file.rb", 1) }

  describe "successfully" do

    let(:ruby_string) {
      <<-RUBY
group :foo
  set value: "ok"
      RUBY
    }

    it "populates the level" do
      subject.read(level)
      level.eql_hash?(
        foo: {
          value: "ok"
        }
      ).must_equal true
    end
  end

  describe "with an error" do

    let(:ruby_string) {
      <<-RUBY
xgroup :foo
  set value: "ok"
      RUBY
    }

    it "provides useful information" do
      begin
        subject.read(level)
      rescue => e
        e.class.must_equal NoMethodError
        e.message.must_equal %(undefined method `xgroup' for <Levels>:Levels::Input::Ruby::DSL)
        e.backtrace.first.must_equal "file.rb:1:in `read'"
      end
    end
  end
end

describe Levels::Input::Ruby::DSL do

  let(:level) { Levels::Level.new("Ruby") }

  subject { Levels::Input::Ruby::DSL.new(level) }

  def define(&block)
    subject.instance_eval(&block)
    subject.close_current_group
  end

  it "defines an empty group" do
    define do
      group :one
    end
    level.defined?(:one).must_equal true
  end

  it "defines a group with keys" do
    define do
      group :one
      set key: "value"
    end
    level.one.key.must_equal "value"
  end

  it "is an error to set a key outside of a group" do
    -> {
      define do
        set key: "value"
      end
    }.must_raise(SyntaxError)
  end

  it "is an error to set a key more than once" do
    -> {
      define do
        group :one
        set key: "value"
        set "key" => "value"
      end
    }.must_raise(RuntimeError)
  end

  it "is an error to define a group more than once" do
    -> {
      subject.group :one
      subject.close_current_group
      subject.group "one"
    }.must_raise(RuntimeError)
  end

  describe "the ways to set a value" do

    before do
      subject.group :one
    end

    def assert_key
      subject.close_current_group
      level.one.key.must_equal "value"
    end

    it "can be set as a ruby 1.9 hash" do
      subject.set key: "value"
      assert_key
    end

    it "can be set as a ruby 1.8 hash" do
      subject.set :key => "value"
      assert_key
    end

    it "is possible to set multiple keys via a hash" do
      subject.set :key => "value", :bar => "foo"
      assert_key
      level.one.bar.must_equal "foo"
    end

    it "can be set with two arguments" do
      subject.set :key, "value"
      assert_key
    end

    it "is an error to pass other types of args" do
      -> { subject.set :a }.must_raise(ArgumentError)
      -> { subject.set :a, 1, :b }.must_raise(ArgumentError)
      -> { subject.set :a, 1, :b, 2 }.must_raise(ArgumentError)
      -> { subject.set :b, :a => 1 }.must_raise(ArgumentError)
    end
  end
end
