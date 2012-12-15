module Levels
  # In order to understand which of many possible values is actually used at
  # runtime, Levels provides an audit trail for each value that's accessed.
  # The audit trail is reported via the Levels::EventHandler interface.
  module Audit

    # Internal: Begin an audit.
    #
    # evaluator - Ducktype #call used to interpret raw values.
    #
    # Returns a Levels::Audit::RootObserver.
    def self.start(evaluator)
      Levels::Audit::RootObserver.new(evaluator)
    end

    autoload :GroupObserver,         'levels/audit/group_observer'
    autoload :NestedGroupObserver,   'levels/audit/nested_group_observer'
    autoload :RootObserver,          'levels/audit/root_observer'
    autoload :Value,                 'levels/audit/value'
    autoload :ValueObserver,         'levels/audit/value_observer'
    autoload :Values,                'levels/audit/values'

  end
end
