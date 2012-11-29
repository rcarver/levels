module Levels
  module Audit
    class GroupObserver

      def initialize(value_observer, user_observer)
        @value_observer = value_observer
        @user_observer = user_observer
      end

      def observe_values(levels, group_key, value_key)
        values = @value_observer.observe_values(levels, group_key, value_key)
        @user_observer.on_values(values)
        values
      end
    end
  end
end
