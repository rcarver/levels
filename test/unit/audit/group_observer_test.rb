require 'helper'

describe Levels::Audit::GroupObserver do

  let(:value_observer) { MiniTest::Mock.new }
  let(:user_observer) { MiniTest::Mock.new }

  subject { Levels::Audit::GroupObserver.new(value_observer, user_observer) }

  it "observes values by finding them and notifying what it found" do
    levels = MiniTest::Mock.new
    group_key = :group
    value_key = :value

    observed_values = "the values"
    value_observer.expect(:observe_values, observed_values, [levels, group_key, value_key])
    user_observer.expect(:on_values, nil, [observed_values])

    returned_values = subject.observe_values(levels, group_key, value_key)
    returned_values.must_equal observed_values
    value_observer.verify
    user_observer.verify
  end
end
