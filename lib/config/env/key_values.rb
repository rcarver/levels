module Config
  module Env
    class KeyValues

      def Key(key)
        case key
        when Config::Env::Key then key
        else Config::Env::Key.new(key)
        end
      end

      def Value(value)
        case value
        when Config::Env::Value then value
        else Config::Env::Value.new(value)
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
        "<Config::Env::KeyValues>"
      end

      alias to_s inspect
    end
  end
end
