module Levels
  # A Configuration is the merging of one or more levels.
  class Configuration
    include Levels::MethodMissing

    # Internal: Initialze a new configuration.
    #
    # levels - Array of Levels::Level.
    #
    def initialize(levels, event_handler = nil)
      @levels = levels
      @event_handler = event_handler || NullEventHandler.new
      @root_observer = Levels::Audit.start(LazyEvaluator.new(self))
    end

    # Public: Set the event handler.
    #
    # event_handler - Levels::EventHandler.
    #
    # Returns nothing.
    def event_handler=(event_handler)
      @event_handler = event_handler
    end

    # Public: Retrieve a group.
    #
    # group_key - Symbol name of the group.
    #
    # Returns a Levels::ConfiguredGroup.
    # Raises Levels::UnknownGroup if the group is not defined.
    def [](group_key)
      raise UnknownGroup unless self.defined?(group_key)
      group_observer = @root_observer.observe_group(@event_handler)
      Levels::ConfiguredGroup.new(@levels, group_key, group_observer)
    end

    # Public: Determine if a group is defined.
    #
    # group_key - Symbol name of the group.
    #
    # Returns a Boolean.
    def defined?(group_key)
      @levels.any? { |level| level.defined?(group_key) }
    end

    def to_s
      "<Levels::Configuration #{@levels.map { |l| l._level_name }.join(', ')}>"
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
