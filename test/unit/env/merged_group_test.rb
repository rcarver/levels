require 'helper'

describe Config::Env::MergedGroup do

  let(:group1) { Config::Env::Group.new("g1", :test, a: 1, b: 2) }
  let(:group2) { Config::Env::Group.new("g2", :test, a: 9, c: 3) }

  subject { Config::Env::MergedGroup.new(:test, [group1, group2]) }

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
      proc { subject.foo }.must_raise Config::Env::UnknownKey
    end
  end
end

