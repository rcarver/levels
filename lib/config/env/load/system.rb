module Config
  module Env
    module Load
      # This loader creates an env level from the system environment
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

        # Initialize a new system loader.
        #
        # template_level - Config::Env::Level that defines the possible
        #                  keys.
        # prefix         - String prefix for the keys (default: no
        #                  prefix).
        #
        def initialize(template_level, prefix = nil, env_hash = ENV)
          @template_level = template_level
          @prefix = prefix
          @env_hash = env_hash
        end

        def load
          hash = {}

          @template_level._groups.each do |group|
            attrs = {}
            prefix = "#{@prefix}#{group._group_name}".upcase
            @env_hash.each do |key, value|
              if key =~ /^#{prefix}_(.+)$/
                attr_name = $1.downcase.to_sym
                if group.defined?(attr_name)
                  # TODO: typecast the value based on the value in the template level.
                  attrs[attr_name] = value
                end
              end
            end
            if attrs.any?
              hash[group._group_name] = attrs
            end
          end

          hash
        end

      end
    end
  end
end
