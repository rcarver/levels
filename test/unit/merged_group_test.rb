require 'helper'

describe Levels::MergedGroup do

  let(:group1) { Levels::Group.new("g1", :test, a: 1, b: 2) }
  let(:group2) { Levels::Group.new("g2", :test, a: 9, c: 3) }

  subject { Levels::MergedGroup.new(:test, [group1, group2]) }

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

  describe "outputs" do

    let(:event_handler) { MiniTest::Mock.new }

    before do
      subject.event_handler = event_handler
    end

    after do
      event_handler.verify
    end

    it "notifies when a single-level, top level variable is used" do
      event_handler.expect(:on_read_from_merged_group, nil, [
        :test,
        :b,
        [
          ["g1", 2]
        ]
      ])
      subject.b
    end

    it "notifies when a single-level, lower level variable is used" do
      event_handler.expect(:on_read_from_merged_group, nil, [
        :test,
        :c,
        [
          ["g2", 3]
        ]
      ])
      subject.c
    end

    it "notifies when a multi-level variable is used" do
      event_handler.expect(:on_read_from_merged_group, nil, [
        :test,
        :a,
        [
          ["g1", 1],
          ["g2", 9]
        ],
      ])
      subject.a
    end

    it "does not notify a bad key" do
      proc { subject.foo }.must_raise Levels::UnknownKey
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

