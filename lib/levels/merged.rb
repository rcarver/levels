module Levels
  # Merging is the union if one or more env levels.
  class Merged
    include Levels::MethodMissing

    # Internal: Initialze a new merge.
    #
    # levels - Array of Levels::Level.
    #
    def initialize(levels, event_handler = nil)
      @levels = levels
      @event_handler = event_handler || NullEventHandler.new
      @root_observer = Levels::Audit.start(LazyEvaluator.new(self))
    end

    def [](group_key)
      raise UnknownGroup unless self.defined?(group_key)
      group_observer = @root_observer.observe_group(@event_handler)
      Levels::MergedGroup.new(@levels, group_key, group_observer)
    end

    # See Levels::Level#defined?.
    def defined?(group_key)
      @levels.any? { |level| level.defined?(group_key) }
    end

    def to_s
      "<Levels::Merged #{@levels.map { |l| l._level_name }.join(', ')}>"
    end

    # Set the event handler.
    def event_handler=(event_handler)
      @event_handler = event_handler
    end

    # Returns an Enumerator which yields [gruop_name, Group#to_enum].
    def to_enum
      Enumerator.new do |y|
        group_keys = Set.new
        @levels.each do |level|
          level.to_enum.each do |name, group|
            group_keys << name
          end
        end
        group_keys.each do |name|
          y << [name, self[name].to_enum]
        end
      end
    end
  end
end
