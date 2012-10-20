module Config
  module Env
    module Input
      # This input 
      class JSON

        def initialize(json_string)
          @json = ::JSON.parse(json_string)
        end

        def read(level)
          @json.each do |group_name, group|
            level.set_group(group_name, group)
          end
        end
      end
    end
  end
end
