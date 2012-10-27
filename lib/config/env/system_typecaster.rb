module Config
  module Env
    class SystemTypecaster

      class SystemKeyFormatter

        def initialize(prefix = nil, joiner = nil)
          @prefix = prefix || ""
          @joiner = joiner || "_"
        end

        def create(*parts)
          (@prefix + parts.join(@joiner)).upcase
        end
      end

      TYPE_SUFFIX = "TYPE"
      ARRAY_DELIMITER_SUFFIX = "DELIMITER"

      def initialize(key_formatter = nil)
        @key_formatter = key_formatter || SystemKeyFormatter.new
      end

      def key(*parts)
        @key_formatter.create(*parts)
      end

      alias k key

      def parse_input(env_hash, key, value, template_value)
        case
        when value.empty? then nil
        when template_value.nil? then input_from_env(env_hash, key, value)
        else input_from_template(key, value, template_value)
        end
      end

      def form_output(enumerator)
        env = {}
        enumerator.each do |group, key, value|
          add_output_keys(env, group, key, value)
        end
        env
      end

    protected

      def input_from_env(env_hash, key, value)
        case env_hash[k(key, TYPE_SUFFIX)]
        when "string"  then value.to_s
        when "integer" then value.to_i
        when "float"   then value.to_f
        when "boolean" then input_boolean(value)
        when "array"
          value.split(":").map do |v|
            input_from_env(env_hash, k(key, TYPE_SUFFIX), v)
          end
        else value.to_s
        end
      end

      def input_from_template(key, value, template_value)
        case template_value
        when String  then value.to_s
        when Integer then value.to_i
        when Float   then value.to_f
        when TrueClass, FalseClass then input_boolean(value)
        when Array
          value.split(":").map do |v|
            input_from_template(key, v, template_value.first)
          end
        else value.to_s
        end
      end

      def input_boolean(value)
        value.match(/^(true|1)$/i) != nil
      end

      def type_key(key)
        k(key, TYPE_SUFFIX)
      end

      def add_output_keys(env, group, key, value)
        case value
        when Array
          env[k(group, key)] = value.join(":")
          env[k(group, key, TYPE_SUFFIX)] = "array"
          env[k(group, key, ARRAY_DELIMITER_SUFFIX)] = ":"
          env[k(group, key, TYPE_SUFFIX, TYPE_SUFFIX)] = output_type_for(value.first)
        else
          env[k(group, key)] = value.to_s
          env[k(group, key, TYPE_SUFFIX)] = output_type_for(value)
        end
      end

      def output_type_for(value)
        case value
        when String, NilClass then "string"
        when Integer then "integer"
        when Float then "float"
        when TrueClass, FalseClass then "boolean"
        when Array then "array"
        else
          raise ArgumentError, "Could not export #{value.class}"
        end
      end

    end
  end
end
