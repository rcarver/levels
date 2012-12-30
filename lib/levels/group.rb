module Levels
  # A group is a set of key/value pairs containing your data.
  #
  # Examples
  #
  #     group = Levels::Group.new(name: "Joe", age: 33)
  #
  #     group.name # => "Joe"
  #     group.age  # => 33
  #
  class Group
    include Levels::MethodMissing

    # Internal: Initialize a new group.
    #
    # data              - Hash of key/values for the group.
    # value_transformer - Proc that takes (key, value) and returns value.
    #
    def initialize(data = {}, value_transformer = nil)
      @values = Levels::KeyValues.new(data)
      @value_transformer = value_transformer || -> key, value { value }
    end

    # Public: Get the value for a key.
    #
    # Returns the value.
    # Raises Levels::UnknownKey if the key is not defined.
    def [](value_key)
      if @values.key?(value_key)
        key, value = @values.pair(value_key)
        @value_transformer.call(key.to_sym, value)
      else
        raise UnknownKey, "#{value_key.inspect} is not defined in #{self}"
      end
    end

    # Public: Determine if a key is defined.
    #
    # Returns a Boolean.
    def defined?(key)
      @values.key?(key)
    end

    def to_s
      "<Levels::Group>"
    end

    # Returns an Enumerator which yields [key, value].
    def to_enum
      Enumerator.new do |y|
        @values.each do |key, value|
          y << [key.to_sym, self[key]]
        end
      end
    end

    def eql_hash?(hash)
      @values == Levels::KeyValues.new(hash)
    end
  end
end
