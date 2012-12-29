require 'helper'

describe Levels::Audit::Value do

  let(:level_name) { "My Level" }
  let(:final)      { true }
  let(:value)      { "hello" }

  subject { Levels::Audit::Value.new(level_name, final) { value } }

  it "exposes the level_name" do
    subject.level_name.must_equal level_name
  end

  it "exposes the value" do
    subject.value.must_equal "hello"
  end

  it "exposes the value as `raw`" do
    subject.raw.must_equal "hello"
  end

  it "inspect's as the value" do
    subject.inspect.must_equal %("hello")
  end

  it "expose finality" do
    a = Levels::Audit::Value.new(level_name, true) { value }
    b = Levels::Audit::Value.new(level_name, false) { value }
    a.must_be :final?
    b.wont_be :final?
  end

  it "exposes recursiveness" do
    subject.wont_be :recursive?

    subject.add_nested_group_observer(MiniTest::Mock.new)

    subject.must_be :recursive?
  end
end
