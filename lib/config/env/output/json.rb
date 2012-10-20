module Config
  module Env
    module Output
      class JSON

        SPACE = " ".freeze

        def initialize(enumerator)
          @enumerator = enumerator
          @json_opts = {
            indent: SPACE * 2,
            space: SPACE * 1,
            space_before: SPACE * 0,
            object_nl: "\n",
            array_nl: "\n",
            allow_nan: false,
            max_nesting: 10
          }
        end

        attr_accessor :json_opts

        def result
          hash = {}
          @enumerator.each do |group_name, group|
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
