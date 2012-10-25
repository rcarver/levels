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
        def initialize(template, prefix = nil, env_hash = ENV)
          @template = template
          @prefix = prefix
          @env_hash = env_hash
        end

        def read(level)
          @template.each do |group_name, group|
            env_data = {}
            group_data = {}
            prefix = "#{@prefix}#{group_name}".upcase
            group.each do |key, value|
              group_data[key.to_sym] = value
            end
            @env_hash.each do |key, value|
              if key =~ /^#{prefix}_(.+)$/
                attr_name = $1.downcase.to_sym
                if group_data.key?(attr_name)
                  # TODO: typecast the value based on the value in the template level.
                  env_data[attr_name] = value
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