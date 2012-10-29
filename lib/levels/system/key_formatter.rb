module Config
  module Env
    module System
      class KeyFormatter

        def initialize(prefix = nil, joiner = nil)
          @prefix = prefix || ""
          @joiner = joiner || "_"
        end

        def create(*parts)
          (@prefix + parts.join(@joiner)).upcase
        end
      end
    end
  end
end
