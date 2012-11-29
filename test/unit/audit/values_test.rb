require 'helper'

describe Levels::Audit::Values do

  let(:group_key) { :group }
  let(:value_key) { :value }
  let(:values)    { [] }

  subject { Levels::Audit::Values.new(group_key, value_key, values) }

  it "exposes the group_key" do
    subject.group_key.must_equal group_key
  end

  it "exposes the value_key" do
    subject.value_key.must_equal value_key
  end

  it "exposes the final value" do
    v1 = MiniTest::Mock.new
    v1.expect(:final?, false)

    v2 = MiniTest::Mock.new
    v2.expect(:final?, true)
    v2.expect(:value, "hello")

    values.concat [v1, v2]

    subject.final_value.must_equal "hello"
  end
end
