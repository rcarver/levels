module Levels
  module Audit
    # The ValueObserver iterates over levels to find the appriate values.  It
    # accumulates all possible values and indicates which is the "final" value.
    class ValueObserver

      # Initialize a new ValueObserver.
      #
      # root_observer - Levels::Audit::RootObserver.
      # evaluator     - Ducktype #call used to interpret raw values.
      #
      def initialize(root_observer, evaluator)
        @root_observer = root_observer
        @evaluator = evaluator
      end

      # Get the possible values for a group+value key. The values are retrieved
      # and evaluated in context of the RootObserver so that recursive values
      # are tracked.
      #
      # levels    - Array of Levels::Level.
      # group_key - Levels::Key.
      # value_key - Levels::Key.
      #
      # Returns a Levels::Audit::Values.
      def observe_values(levels, group_key, value_key)
        valid_levels = levels.find_all do |level|
          level.defined?(group_key) &&
          level[group_key].defined?(value_key)
        end

        values = valid_levels.map.with_index do |level, index|
          group = level[group_key]

          Value.new(level._level_name, index == valid_levels.size - 1) do |value|
            @root_observer.with_current_value(value) do
              @evaluator.call(group[value_key])
            end
          end
        end

        Values.new(group_key, value_key, values)
      end
    end
  end
end
