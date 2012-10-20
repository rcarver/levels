module Config
  module Env
    # An env level is a collection of groups. Your env will
    # typically involve multiple levels such as base, cluster and node. Each
    # level is stored separately so that, for example, when a lower level
    # overrides the values at a higher level the behavior is clear and
    # traceable. Levels are combined via the Config::Env::Merged
    # model which defines the override and union symantics.
    class Level
      include Config::Env::MethodMissing

      # Internal: Initialize a new level.
      #
      # name - String name of the level.
      #
      def initialize(name)
        @name = name
        @groups = {}
      end

      # Public: Get a group by name.
      #
      # group_name - Symbol name of the group.
      #
      # Returns a Config::Env::Group.
      # Raises Config::Env::UnknownGroup if the group is not defined.
      def [](group_name)
        @groups[group_name] or raise UnknownGroup, "#{group_name} group is not defined"
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
        if @groups[group_name.to_sym]
          raise DuplicateGroup, "#{group_name} has already been defined"
        end
        @groups[group_name.to_sym] = Group.new(@name, group_name.to_sym, hash)
      end

      def to_s
        "<Config::Env::Level #{@name.inspect}>"
      end

      # Returns an Enumerator which yields [group_name, Group#to_enum].
      def to_enum
        Enumerator.new do |y|
          @groups.each do |name, group|
            y << [name, group.to_enum]
          end
        end
      end

      # Returns a Hash with Symbol keys.
      def to_hash
        hash = {}
        @groups.each do |name, group|
          hash[name] = group.to_hash
        end
        hash
      end

      def _level_name
        @name
      end

      def _groups
        @groups.values
      end

    end
  end
end
