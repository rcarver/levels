module Config
  module Env
    module Output
      class System

        def initialize(prefix = nil)
          @prefix = prefix
        end

        def generate(enumerator)
          vars = []
          enumerator.each do |group_name, group|
            group.each do |key, value|
              vars.concat vars_for(group_name, key, value)
            end
          end
          vars.map { |var| "export #{var}" }.join("\n")
        end

      protected

        def vars_for(group_name, key, value)
          parts = []
          parts << @prefix.chomp("_") if @prefix
          parts << group_name.to_s.upcase
          parts << key.to_s.upcase
          left = parts.join("_")
          right = "\"#{value}\""
          ["#{left}=#{right}"]
        end

      end
    end
  end
end
