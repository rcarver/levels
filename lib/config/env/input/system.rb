module Config
  module Env
    module Input
      # This input creates an env level from the system environment
      # (ENV in ruby). It does so by using an existing level as a
      # template for the group names and values. For each value, it
      # attempts to typecast a String value into the same type found in
      # the template.
      #
      # Examples
      #
      #     # Given a template level with a single group:
      #     settings: {
      #       hostname: "example.com",
      #       workers: 5,
      #       queues: ["low", "high", "other"]
      #     }
      #
      #     # These environment variables will set new values.
      #     SETTINGS_HOSTNAME=foo.com
      #     SETTINGS_WORKERS=1
      #     SETTINGS_QUEUES=high:low:other
      #
      class System

        # Initialize a new system reader.
        #
        # template - Enumerator that defines the possible keys.
        # prefix   - String prefix for the keys (default: no
        #            prefix).
        #
        def initialize(template, key_formatter = nil, env_hash = ENV)
          @template = template
          @env_hash = env_hash
          @key_formatter = key_formatter || Config::Env::System::KeyFormatter.new
          @key_parser = Config::Env::System::KeyParser.new(@key_formatter)
        end

        def read(level)
          @template.each do |group_name, group|
            env_data = {}
            group_data = {}
            group.each do |key, value|
              group_data[key.to_sym] = value
            end
            @env_hash.each do |key, value|
              match_key = @key_formatter.create(group_name, "(.+)")
              matcher = Regexp.new("^#{match_key}$")
              if key =~ matcher
                attr_name = $1.downcase.to_sym
                if group_data.key?(attr_name)
                  cast_value = @key_parser.parse(@env_hash, key, group_data[attr_name])
                  env_data[attr_name] = cast_value
                end
              end
            end
            if env_data.any?
              level.set_group(group_name, env_data)
            end
          end
        end
      end
    end
  end
end
