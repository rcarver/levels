module Config
  module Env
    module Output
      class JSON

        SPACE = " ".freeze
        JSON_OPTS = {
          indent: SPACE * 2,
          space: SPACE * 1,
          space_before: SPACE * 0,
          object_nl: "\n",
          array_nl: "\n",
          allow_nan: false,
          max_nesting: 10
        }

        def initialize(json_opts = nil)
          @json_opts = json_opts || JSON_OPTS
        end

        def generate(enumerator)
          hash = {}
          enumerator.each do |group_name, group|
            hash[group_name] = {}
            group.each do |key, value|
              hash[group_name][key] = value
            end
          end
          ::JSON.generate(hash, @json_opts)
        end

      end
    end
  end
end
