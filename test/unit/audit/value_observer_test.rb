require 'helper'

describe Levels::Audit::ValueObserver do

  let(:root_observer_class) {
    Class.new do

      def initialize
        @values = []
      end

      def with_current_value(value)
        @values << value
        yield
      end

      def raw_values
        @values.map { |v| v.raw }
      end
    end
  }

  let(:root_observer)  { root_observer_class.new }
  let(:lazy_evaluator) { MiniTest::Mock.new }

  after do
    lazy_evaluator.verify
  end

  subject { Levels::Audit::ValueObserver.new(root_observer, lazy_evaluator) }

  it "traverses all levels to find values" do
    level1 = Levels::Level.new("one")
    level1.set_group(:group, a: 1)

    level2 = Levels::Level.new("two")
    level2.set_group(:group, a: 2)

    level3 = Levels::Level.new("two")
    level3.set_group(:group, b: 0)

    level4 = Levels::Level.new("two")

    # A Level for each case, and two with applicable values.
    levels = [level1, level2, level3, level4]

    # Translate the initial values into something else.
    lazy_evaluator.expect(:call, 11, [Levels::Value.new(1)])
    lazy_evaluator.expect(:call, 22, [Levels::Value.new(2)])

    values = subject.observe_values(levels, :group, :a)

    values.must_be_instance_of Levels::Audit::Values
    values.group_key.must_equal :group
    values.value_key.must_equal :a

    # The observer was passed each Value
    root_observer.raw_values.must_equal [11, 22]

    # The returned Values is made up of each Value.
    values.map { |v| v.raw }.must_equal [11, 22]
  end
end
