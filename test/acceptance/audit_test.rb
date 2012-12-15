require 'helper'

describe "acceptance: the audit observers" do

  # This test requires a lot of collaborators, but hopefully shows how the
  # auditor works as a whole.

  let(:event_handler_class) {
    Class.new do

      def initialize
        @current_key = nil
        @captured = Hash.new { |h, k| h[k] = [] }
      end

      attr_reader :captured

      def on_values(values)
        @current_key = values.value_key
        values.each do |value|
          @captured[@current_key] << value.raw
          value.notify(self)
        end
        @current_key = nil
      end

      def on_nested_values(values)
        values.each do |value|
          @captured[@current_key] << [values.value_key, value.raw]
        end
      end
    end
  }

  # The levels that will be merged.
  let(:levels) { [] }

  # The merged view of the levels.
  let(:merged) { Levels.merge(*levels) }

  # Computed values are evaluated against the merged levels.
  let(:lazy_evaluator) { Levels::LazyEvaluator.new(merged) }

  # The root observer performing the audit.
  let(:root_observer) { Levels::Audit.start(lazy_evaluator) }

  before do
    level1 = Levels::Level.new("one")
    level1.set_group(:group1, a: 1)
    level1.set_group(:group2, x: -> { "a = #{group1.a}, b = #{group2.b}" })

    level2 = Levels::Level.new("two")
    level2.set_group(:group1, a: 2)
    level2.set_group(:group2, b: 3)

    levels << level1
    levels << level2

    # The auditor must be assigned to the merged levels, else nested values get
    # confused since the value is ultimately accessed via the LazyEvaluator's
    # levels reference. The point is, we're doing something weird here by using
    # the auditor directly.
    merged.instance_variable_set(:@root_observer, root_observer)
  end

  # A custom event handler to collect the values that are observed.
  let(:event_handler) { event_handler_class.new }

  # Get the full audit trail for a group.value read.
  def observe_values(group_key, value_key)
    group_observer = root_observer.observe_group(event_handler)
    group_observer.observe_values(levels, group_key, value_key)
  end

  it "handles simple values" do
    values = observe_values(:group1, :a)

    event_handler.captured.must_equal a: [1, 2]

    values.final_value.must_equal 2
  end

  it "handles complex nested values" do
    values = observe_values(:group2, :x)

    event_handler.captured.must_equal x: [
      "a = 2, b = 3",
      [:a, 1],
      [:a, 2],
      [:b, 3]
    ]

    values.final_value.must_equal "a = 2, b = 3"
  end

  it "returns empty values for a non-existent key" do
    values = observe_values(:no_group, :foo)
    event_handler.captured.must_equal({})
    values.must_be :empty?

    values = observe_values(:group1, :no_key)
    event_handler.captured.must_equal({})
    values.must_be :empty?
  end
end
