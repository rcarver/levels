module Levels
  class Value

    def initialize(value)
      @value = value
    end

    def value
      @value
    end

    def validate!
      raise Levels::NullValueError if nil?
    end

    def nil?
      @value.nil?
    end

    def eql?(other)
      other.is_a?(self.class) && other.value == value
    end

    alias == eql?

    def ===(other)
      case other
      when Class
        @value.class == other
      else
        @value == other
      end
    end
  end
end
