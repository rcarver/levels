module Levels
  class KeyValues

    def Key(key)
      case key
      when Levels::Key then key
      else Levels::Key.new(key)
      end
    end

    def Value(value)
      case value
      when Levels::Value then value
      else Levels::Value.new(value)
      end
    end

    include Enumerable

    def initialize(data = nil)
      @hash = {}
      data.each { |k, v| self[k] = v } if data
    end

    def [](key)
      @hash[Key(key)]
    end

    def pair(key)
      return Key(key), self[key]
    end

    def []=(key, value)
      @hash[Key(key)] = value
    end

    def key?(key)
      @hash.key?(Key(key))
    end

    def each(&block)
      @hash.each(&block)
    end

    def eql?(other)
      self.class == other.class && @hash.eql?(other.instance_variable_get(:@hash))
    end

    alias == eql?

    def hash
      self.class.hash ^ @hash.hash
    end

    def inspect
      "<Levels::KeyValues>"
    end

    alias to_s inspect
  end
end
