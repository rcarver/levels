module Levels
  class Key

    def initialize(key)
      @key = key
    end

    def to_sym
      @key.to_sym
    end

    def eql?(other)
      other.class == self.class && to_sym == other.to_sym
    end

    alias == eql?

    def hash
      self.class.hash ^ to_sym.hash
    end

    def inspect
      "<Levels::Key #{to_sym.inspect}>"
    end

    alias to_s inspect
  end
end
