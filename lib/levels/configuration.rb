module Levels
  # A Configuration is the merging of one or more levels. This is the top level
  # object that you will interact with most.
  #
  # Examples
  #
  #   # In this example we'll represent a Level as a Hash.
  #   level1 = { group1: { key1: 1 } }
  #   level2 = { group1: { key1: 2, key2: 2 }, group2: { x: 9 } }
  #
  #   # The configuration exposes each group that exists in a Level.
  #   config = Levels::Configuration.new([level1, level2])
  #
  #   # A Group may be accessed via hash syntax.
  #   config[:group1] # => { key1: 2, key2: 2 }
  #   # Or method syntax.
  #   config.group1 # => { key1: 2, key2: 2 }
  #
  #   # You can check if a Group exists.
  #   config.defined?(:group1) # => true
  #   config.group1? # => true
  #
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

    # Public: Set the event handler. The event handler is notified whenever a
    # key is read; allowing you to track exactly what is and isn't used at
    # runtime.
    #
    # event_handler - Levels::EventHandler.
    #
    # Returns nothing.
    def event_handler=(event_handler)
      @event_handler = event_handler
    end

    # Public: Retrieve a group. The resulting group is the union of the named
    # group from each Level that defines that group.
    #
    # group_key - Symbol name of the group.
    #
    # Examples
    #
    #   # In this example we'll represent a Level as a Hash.
    #   level1 = { group: { key1: 1 } }
    #   level2 = { group: { key1: 2, key2: 2 } }
    #
    #   config = Levels::Configuration.new([level1, level2])
    #   config[:group] # => { key1: 2, key2: 2 }
    #
    # Returns a Levels::ConfiguredGroup.
    # Raises Levels::UnknownGroup if the group is not defined.
    def [](group_key)
      raise UnknownGroup unless self.defined?(group_key)
      group_observer = @root_observer.observe_group(@event_handler)
      group = Levels::ConfiguredGroup.new(@levels, group_key, group_observer)
      GroupDecorator.new(group)
    end

    class GroupDecorator
      include Levels::MethodMissing

      def initialize(group)
        @group = group
      end

      def [](value_key)
        value = @group[value_key]
        value.validate!
        value.value
      end

      def defined?(value_key)
        @group.defined?(value_key)
      end

      def to_s
        @group.to_s
      end

      def to_enum
        @group.to_enum
      end
    end

    # Public: Determine if a group is defined. A group is defined if it exists
    # in any Level.
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
