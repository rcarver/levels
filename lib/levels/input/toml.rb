module Levels
  module Input
    # This input loads TOML documents.
    class TOML

      def initialize(toml_string)
        @toml = ::TOML.load(toml_string)
      end

      def read(level)
        @toml.each do |group_name, group|
          level.set_group(group_name, group)
        end
      end
    end
  end
end

