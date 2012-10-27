module Config
  module Env
    module Output
      class System

        def initialize(system_typecaster = nil)
          @system_typecaster = system_typecaster || Config::Env::SystemTypecaster.new
        end

        def generate(enumerator)
          flat_enum = Enumerator.new do |y|
            enumerator.each do |group_name, group|
              group.each do |key, value|
                y << [group_name, key, value]
              end
            end
          end
          vars = @system_typecaster.form_output(flat_enum)
          vars.map { |k, v| "export #{k}=\"#{v}\"" }.join("\n")
        end
      end
    end
  end
end
