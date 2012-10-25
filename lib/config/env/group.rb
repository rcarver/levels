module Config
  module Env
    # An env group is a set of key/value pairs containing the actual data.
    #
    # Examples
    #
    #     hash = { name: "Joe", age: 33 }
    #     group = Config::Env::Group.new("Global", :person, hash)
    #
    #     group.name # => "Joe"
    #     group.age  # => 33
    #
    class Group
      include Config::Env::MethodMissing

      # Internal: Initialize a new group.
      #
      # level_name        - String name of the level.
      # group_key         - Symbol name of the group.
      # data              - Hash of key/values for the group.
      # value_transformer - Proc that takes (key, value) and returns value.
      #
      def initialize(level_name, group_key, data = {}, value_transformer = nil)
        @level_name = level_name.to_s
        @group_key = Config::Env::Key.new(group_key)
        @key_values = Config::Env::KeyValues.new(data)
        @value_transformer = value_transformer || -> key, value { value }
      end

      # Public: Get the value for a key.
      #
      # Returns the value.
      # Raises Config::Env::UnknownKey if the key is not defined.
      def [](key)
        if @key_values.key?(key)
          key, value = @key_values.pair(key)
          @value_transformer.call(key.to_sym, value)
        else
          raise UnknownKey, "#{key.inspect} is not defined in #{self}"
        end
      end

      # Public: Determine if a key is defined.
      #
      # Returns a Boolean.
      def defined?(key)
        @key_values.key?(key)
      end

      def to_s
        "<Config::Env::Group #{@group_key.to_sym} (#{@level_name.inspect})>"
      end

      # Returns an Enumerator which yields [key, value].
      def to_enum
        Enumerator.new do |y|
          @key_values.each do |key, value|
            y << [key, self[key]]
          end
        end
      end

      def _level_name
        @level_name
      end

      def eql_hash?(hash)
        @key_values == Config::Env::KeyValues.new(hash)
      end

    end
  end
end

