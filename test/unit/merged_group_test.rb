require 'helper'

describe Levels::MergedGroup do

  let(:group1) { Levels::Group.new("g1", :test, a: 1, b: 2) }
  let(:group2) { Levels::Group.new("g2", :test, a: 9, c: 3) }

  let(:event_handler) { nil }
  let(:lazy_evaluator) { nil }

  subject { Levels::MergedGroup.new(:test, [group1, group2], event_handler, lazy_evaluator) }

  it "allows hash access to any key" do
    subject[:a].must_equal 9
    subject[:b].must_equal 2
    subject[:c].must_equal 3
  end

  it "allows method access" do
    subject.a.must_equal 9
    subject.b.must_equal 2
    subject.c.must_equal 3
  end

  describe "with a lazy evaluator" do

    let(:lazy_evaluator) { -> value { value + 100 } }

    it "passes it through" do
      subject.a.must_equal 109
      subject[:a].must_equal 109
    end
  end

  describe "outputs" do

    let(:event_handler) { MiniTest::Mock.new }

    before do
      # Because minitest's expect doesn't yield, we'll implement on_evaluate on
      # the mock object, then call to another method that we can set the method
      # expectation on. So, for any test below, expect on `ex_evaluate` instead
      # of `on_evaluate`.
      def event_handler.on_evaluate(group_name, key, level_name)
        self.ex_evaluate(group_name, key, level_name)
        yield
      end
    end

    after do
      event_handler.verify
    end

    it "notifies when a single-level, top level variable is used" do
      event_handler.expect(:on_read,     nil, [:test, :b])
      event_handler.expect(:ex_evaluate, nil, [:test, :b, "g1"])
      event_handler.expect(:on_values,   nil, [:test, :b, [
        ["g1", 2]
      ]])
      subject.b
    end

    it "notifies when a single-level, lower level variable is used" do
      event_handler.expect(:on_read,     nil, [:test, :c])
      event_handler.expect(:ex_evaluate, nil, [:test, :c, "g2"])
      event_handler.expect(:on_values,   nil, [:test, :c, [
        ["g2", 3]
      ]])
      subject.c
    end

    it "notifies when a multi-level variable is used" do
      event_handler.expect(:on_read,     nil, [:test, :a])
      event_handler.expect(:ex_evaluate, nil, [:test, :a, "g1"])
      event_handler.expect(:ex_evaluate, nil, [:test, :a, "g2"])
      event_handler.expect(:on_values,   nil, [:test, :a, [
        ["g1", 1],
        ["g2", 9]
      ]])
      subject.a
    end

    it "does not notify a bad key" do
      proc { subject.foo }.must_raise Levels::UnknownKey
    end

    describe "with a lazy evaluator" do

      let(:lazy_evaluator) { -> value { value + 100 } }

      it "notifies the evaluated value" do
        event_handler.expect(:on_read,     nil, [:test, :a])
        event_handler.expect(:ex_evaluate, nil, [:test, :a, "g1"])
        event_handler.expect(:ex_evaluate, nil, [:test, :a, "g2"])
        event_handler.expect(:on_values,   nil, [:test, :a, [
          ["g1", 101],
          ["g2", 109]
        ]])
        subject.a
      end
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
        [:a, 9],
        [:b, 2],
        [:c, 3]
      ]
      result.sort.must_equal expected.sort
    end
  end
end

