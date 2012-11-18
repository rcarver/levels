module Levels
  module Output
    class YAML

      def generate(enumerator)
        hash = {}
        enumerator.each do |group_name, group|
          hash[group_name.to_s] = {}
          group.each do |key, value|
            hash[group_name.to_s][key.to_s] = value
          end
        end
        ::YAML.dump(hash)
      end

    end
  end
end

