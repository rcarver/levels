require 'helper'

describe Levels::MergedGroup do

  let(:levels) { [] }
  let(:group_observer) { MiniTest::Mock.new }

  subject { Levels::MergedGroup.new(levels, :test, group_observer) }

  def define_value(key, value)
    level = Levels::Level.new("one")
    level.set_group(:test, key => value)
    levels << level
  end

  def observe_value(key, value)
    observed_values = MiniTest::Mock.new
    observed_values.expect(:final_value, value)
    group_observer.expect(:observe_values, observed_values, [levels, :test, key])
  end

  describe "checking value existence" do

    before do
      define_value :a, nil
    end

    it "allows defined?" do
      subject.defined?(:a).must_equal true
    end

    it "allows method access" do
      subject.a?.must_equal true
    end
  end

  describe "reading values" do

    before do
      define_value :a, nil
      observe_value :a, 1
    end

    it "allows hash access to any key" do
      subject[:a].must_equal 1
    end

    it "allows method access" do
      subject.a.must_equal 1
    end
  end

  describe "#to_enum" do

    before do
      define_value :a, nil
      observe_value :a, 1
    end

    it "returns an Enumerator" do
      subject.to_enum.must_be_instance_of Enumerator
    end

    it "iterates over all keys and values" do
      result = subject.to_enum.map do |k, v|
        [k.to_sym, v]
      end
      expected = [
        [:a, 1],
      ]
      result.sort.must_equal expected.sort
    end
  end
end

