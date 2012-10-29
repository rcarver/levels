module Levels
  module Output
    class System

      def initialize(key_formatter = nil)
        @key_formatter = key_formatter || Levels::System::KeyFormatter.new
        @key_generator = Levels::System::KeyGenerator.new(key_formatter)
      end

      def generate(enumerator)
        flat_enum = Enumerator.new do |y|
          enumerator.each do |group_name, group|
            group.each do |key, value|
              y << [group_name, key, value]
            end
          end
        end
        vars = @key_generator.generate(flat_enum)
        vars.map { |k, v| "export #{k}=#{quote v}" }.join("\n")
      end

    protected

      def quote(value)
        %("#{value}")
      end
    end
  end
end
