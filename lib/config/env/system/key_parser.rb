module Config
  module Env
    module System
      class KeyParser

        def initialize(key_formatter = nil)
          @key_formatter = key_formatter || KeyFormatter.new
        end

        def parse(env_hash, key, template_value)
          value = env_hash[key]
          typecast_info = env_hash[k(key, TYPE_SUFFIX)]
          parse_any(env_hash, key, value, typecast_info, template_value)
        end

      protected

        def k(*parts)
          @key_formatter.create(*parts)
        end

        def parse_any(env_hash, key, value, typecast_info, template_value)
          case
          when value.empty?         then nil
          when !typecast_info.nil?  then parse_from_typecast(env_hash, key, value, typecast_info)
          when !template_value.nil? then parse_from_template(env_hash, key, value, template_value)
          else value.to_s
          end
        end

        def parse_from_typecast(env_hash, key, value, typecast_info)
          case typecast_info
          when "string", nil then value.to_s
          when "integer"     then value.to_i
          when "float"       then value.to_f
          when "boolean"     then boolean(value)
          when "array"       then array(env_hash, key, value, nil)
          else raise ArgumentError, "Unknown typecast to #{typecast_info.inspect}"
          end
        end

        def parse_from_template(env_hash, key, value, template_value)
          case template_value
          when String     then value.to_s
          when Integer    then value.to_i
          when Float      then value.to_f
          when TrueClass  then boolean(value.to_s)
          when FalseClass then boolean(value.to_s)
          when Array      then array(env_hash, key, value, template_value.first)
          else raise ArgumentError, "Unknown template value of type #{template_value.class}"
          end
        end

        def array(env_hash, key, value, template_value)
          value_typecast_info = env_hash[k(key, TYPE_SUFFIX, TYPE_SUFFIX)]
          delimiter = env_hash[k(key, ARRAY_DELIMITER_SUFFIX)] || ":"
          value.split(delimiter).map do |v|
            parse_any(env_hash, key, v, value_typecast_info, template_value)
          end
        end

        def boolean(value)
          value.match(/^(true|1)$/i) != nil
        end

      end
    end
  end
end

