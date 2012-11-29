module Levels
  module Audit
    class ValueObserver

      def initialize(root_observer, lazy_evaluator)
        @root_observer = root_observer
        @lazy_evaluator = lazy_evaluator
      end

      def observe_values(levels, group_key, value_key)
        valid_levels = levels.find_all do |level|
          level.defined?(group_key) &&
          level[group_key].defined?(value_key)
        end

        values = valid_levels.map.with_index do |level, index|
          group = level[group_key]

          Value.new(level._level_name, index == valid_levels.size - 1) do |value|
            @root_observer.with_current_value(value) do
              @lazy_evaluator.call(group[value_key])
            end
          end
        end

        Values.new(group_key, value_key, values)
      end
    end
  end
end
