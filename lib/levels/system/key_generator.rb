module Config
  module Env
    module System
      class KeyGenerator

        def initialize(key_formatter = nil)
          @key_formatter = key_formatter || KeyFormatter.new
        end

        def generate(enumerator)
          env = {}
          enumerator.each do |group, key, value|
            add_keys(env, group, key, value)
          end
          env
        end

      protected

        def k(*parts)
          @key_formatter.create(*parts)
        end

        def add_keys(env, group, key, value)
          case value
          when Array
            env[k(group, key)] = value.join(":")
            env[k(group, key, TYPE_SUFFIX)] = "array"
            env[k(group, key, ARRAY_DELIMITER_SUFFIX)] = ":"
            env[k(group, key, TYPE_SUFFIX, TYPE_SUFFIX)] = type_for(value.first)
          else
            env[k(group, key)] = value.to_s
            env[k(group, key, TYPE_SUFFIX)] = type_for(value)
          end
        end

        def type_for(value)
          case value
          when String, NilClass then "string"
          when Integer          then "integer"
          when Float            then "float"
          when TrueClass, FalseClass then "boolean"
          when Array            then "array"
          else
            raise ArgumentError, "Could not export #{value.class}"
          end
        end

      end
    end
  end
end
