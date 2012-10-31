require 'helper'

describe Levels::LazyEvaluator do

  let(:level) { Levels::Level.new("level") }

  subject { Levels::LazyEvaluator.new(level) }

  it "returns a value" do
    subject.call(123).must_equal 123
  end

  it "executes a proc" do
    subject.call(-> { 123 }).must_equal 123
  end

  it "executes a proc recursively" do
    subject.call(-> { -> { 123 } }).must_equal 123
  end

  it "allows the level to be accessed directly" do
    level.set_group(:sample, message: "hello")
    subject.call(-> { sample.message }).must_equal "hello"
    subject.call(-> { sample[:message] }).must_equal "hello"
    subject.call(-> { sample.defined?(:message) }).must_equal true
    subject.call(-> { sample.message? }).must_equal true
  end

  it "allows shell style interpolation" do
    skip "for now"
    level.set_group(:sample, message: "hello")
    subject.call("${SAMPLE_HELLO} world").must_equal "hello world"
  end
end
