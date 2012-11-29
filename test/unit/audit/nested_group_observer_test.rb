require 'helper'

describe Levels::Audit::NestedGroupObserver do

  let(:value_observer) { MiniTest::Mock.new }

  subject { Levels::Audit::NestedGroupObserver.new(value_observer) }

  it "observes values by collecting them, then notifying when asked" do
    levels = MiniTest::Mock.new
    group_key = :group
    value_key = :value

    observed_values = "the values"
    value_observer.expect(:observe_values, observed_values, [levels, group_key, value_key])

    returned_values = subject.observe_values(levels, group_key, value_key)
    returned_values.must_equal observed_values
    value_observer.verify

    user_observer = MiniTest::Mock.new
    user_observer.expect(:on_values, nil, [observed_values])

    subject.notify_nested(user_observer)
    user_observer.verify
  end
end

