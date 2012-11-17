require 'yaml'

module Levels
  module Input
    class YAML

      def initialize(yaml_string)
        @yaml = ::YAML.load(yaml_string)
      end

      def read(level)
        @yaml.each do |group_name, group|
          level.set_group(group_name, group)
        end
      end
    end
  end
end

