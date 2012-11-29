module Levels
  module Audit

    def self.start(lazy_evaluator)
      Levels::Audit::RootObserver.new(lazy_evaluator)
    end

    autoload :GroupObserver,         'levels/audit/group_observer'
    autoload :NestedGroupObserver,   'levels/audit/nested_group_observer'
    autoload :RootObserver,          'levels/audit/root_observer'
    autoload :Value,                 'levels/audit/value'
    autoload :ValueObserver,         'levels/audit/value_observer'
    autoload :Values,                'levels/audit/values'

  end
end
