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

  specify "#final" do
    v1 = Levels::Audit::Value.new("a", false)
    v2 = Levels::Audit::Value.new("a", true)

    values.concat [v1, v2]

    subject.final.must_equal v2
  end

  specify "#final_value" do
    v1 = Levels::Audit::Value.new("a", false, "no")
    v2 = Levels::Audit::Value.new("a", true, "hello")

    values.concat [v1, v2]

    subject.final_value.must_equal "hello"
  end

  specify "#each is Enumerable" do
    subject.map.must_be_instance_of Enumerator
  end

  specify "#only_final?" do
    v1 = MiniTest::Mock.new
    v1.expect(:final?, false)
    v2 = MiniTest::Mock.new
    v2.expect(:final?, true)

    subject.wont_be :only_final?

    values << v2
    subject.must_be :only_final?

    values << v1
    subject.wont_be :only_final?
  end

  specify "#recursive?" do
    v1 = MiniTest::Mock.new
    2.times { v1.expect(:recursive?, false) }
    v2 = MiniTest::Mock.new
    v2.expect(:recursive?, true)

    subject.wont_be :recursive?

    values << v1
    subject.wont_be :recursive?

    values << v2
    subject.must_be :recursive?
  end

  specify "#size" do
    values.size.must_equal 0

    values << MiniTest::Mock.new

    values.size.must_equal 1
  end

  specify "#empty?" do
    values.must_be :empty?

    values << MiniTest::Mock.new

    values.wont_be :empty?
  end
end
