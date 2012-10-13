module Config
  module Env
    # Merging is the union if one or more env levels.
    class Merged
      include Config::Env::MethodMissing

      # Internal: Initialze a new merge.
      #
      # levels - Array of Config::Env::Level.
      #
      def initialize(levels)
        @levels = levels
      end

      # See Config::Env::Level#[].
      def [](group_name)
        levels = @levels.find_all { |level| level.defined?(group_name) }
        raise UnknownGroup if levels.empty?

        groups = levels.map { |level| level[group_name] }
        Config::Env::MergedGroup.new(group_name, groups)
      end

      # See Config::Env::Level#defined?.
      def defined?(group_name)
        @levels.any? { |level| level.defined?(group_name) }
      end

      def to_s
        "<Config::Env::Merged #{@levels.map { |l| l._level_name }.join(', ')}>"
      end

    end
  end
end

