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

      # Returns an Enumerator which yields [gruop_name, Group#to_enum].
      def to_enum
        Enumerator.new do |y|
          group_names = Set.new
          @levels.each do |level|
            level.to_enum.each do |name, group|
              group_names << name
            end
          end
          group_names.each do |name|
            y << [name, self[name].to_enum]
          end
        end
      end
    end
  end
end

