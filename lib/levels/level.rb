module Levels
  # A Level is a named set of groups. A Configuration is made up of multiple
  # levels with clear semantics on how those levels are merged. You generally won't
  # instantiate a Level directly, but instead load one from an external source.
  #
  # Examples
  #
  #     level = Levels::Level.new("My Level")
  #
  #     level.set_group(:group1, a: 1, b: 2)
  #     level.set_group(:group2, c: 3, d: 4)
  #
  #     level.group1 # => { a: 1, b: 2 }
  #     level.group2 # => { c: 3, d: 4 }
  #
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
      @groups[group_name] = Group.new(hash)
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
