require 'helper'

describe Levels::Audit::RootObserver do

  let(:lazy_evaluator) { MiniTest::Mock.new }
  let(:user_observer)  { MiniTest::Mock.new }

  subject { Levels::Audit::RootObserver.new(lazy_evaluator) }

  describe "#observe_group without a current value" do

    it "returns a group observer" do
      group_observer = subject.observe_group(user_observer)
      group_observer.must_be_instance_of Levels::Audit::GroupObserver
    end
  end

  describe "#with_current_value" do

    it "sets the current value for the life of the block" do
      value = "the value"
      subject.instance_variable_get(:@current_value).must_be_nil
      subject.with_current_value(value) do
        subject.instance_variable_get(:@current_value).must_equal value
      end
      subject.instance_variable_get(:@current_value).must_be_nil
    end
  end

  describe "#observe_group with a current value" do

    it "returns a nested group observer, and adds that observer to the current value" do
      value = MiniTest::Mock.new
      value.expect(:add_nested_group_observer, nil, [Levels::Audit::NestedGroupObserver])

      group_observer = nil
      subject.with_current_value(value) do
        group_observer = subject.observe_group(user_observer)
      end

      group_observer.must_be_instance_of Levels::Audit::NestedGroupObserver
    end
  end
end
