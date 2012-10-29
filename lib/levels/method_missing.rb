module Levels
  # Enables dot syntax for levels and groups.
  module MethodMissing

    def method_missing(message, *args, &block)
      raise ArgumentError, "arguments are not allowed: #{message}(#{args.inspect})" if args.any?
      if message =~ /^(.*)\?$/
        self.defined?($1.to_sym)
      else
        self[message]
      end
    end
  end
end
