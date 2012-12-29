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

    # It's impossible to do any kind of comparison
    # on this mock object, so we'll make sure it's
    # the right one by talking to it.
    v2.expect(:ping!, nil)

    values.concat [v1, v2]

    subject.final.ping!
    v2.verify
  end

  it "exposes the final value's value" do
    v1 = MiniTest::Mock.new
    v1.expect(:final?, false)

    v2 = MiniTest::Mock.new
    v2.expect(:final?, true)
    v2.expect(:value, "hello")

    values.concat [v1, v2]

    subject.final_value.must_equal "hello"
  end

  it "defines #empty?" do
    values.must_be :empty?

    v = MiniTest::Mock.new
    values.concat [v]

    values.wont_be :empty?
  end

  it "defines #size" do
    values.size.must_equal 0

    v = MiniTest::Mock.new
    values.concat [v]

    values.size.must_equal 1
  end
end
