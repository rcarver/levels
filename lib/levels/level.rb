module Levels
  # An env level is a collection of groups. Your env will
  # typically involve multiple levels such as base, cluster and node. Each
  # level is stored separately so that, for example, when a lower level
  # overrides the values at a higher level the behavior is clear and
  # traceable. Levels are combined via the Levels::Merged
  # model which defines the override and union symantics.
  class Level
    include Levels::MethodMissing

    # Internal: Initialize a new level.
    #
    # name - String name of the level.
    #
    def initialize(name)
      @name = name
      @groups = Levels::KeyValues.new
    end

    # Public: Get a group by name.
    #
    # group_name - Symbol name of the group.
    #
    # Returns a Levels::Group.
    # Raises Levels::UnknownGroup if the group is not defined.
    def [](group_name)
      @groups[group_name] or raise UnknownGroup, "#{group_name.inspect} group is not defined"
    end

    # Public: Determine if a group has been defined.
    #
    # Returns a Boolean.
    def defined?(group_name)
      @groups.key?(group_name)
    end

    # Internal: Define a group.
    #
    # group_name - Symbol name of the group.
    # hash       - Hash of values.
    #
    # Returns nothing.
    def set_group(group_name, hash)
      if @groups.key?(group_name)
        raise DuplicateGroup, "#{group_name} has already been defined"
      end
      @groups[group_name] = Group.new(@name, group_name, hash)
    end

    def to_s
      "<Levels::Level #{@name.inspect}>"
    end

    # Returns an Enumerator which yields [group_name, Group#to_enum].
    def to_enum
      Enumerator.new do |y|
        @groups.each do |name, group|
          y << [name.to_sym, group.to_enum]
        end
      end
    end

    def _level_name
      @name
    end

    def eql_hash?(hash)
      key_values = Levels::KeyValues.new(hash)
      @groups.all? { |name, group| group.eql_hash?(key_values[name]) }
    end
  end
end