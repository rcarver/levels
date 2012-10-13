module Config
  module Env
    module Loggable

      # Delegate Config::Env::Loggable to Config::Core::Loggable if it's
      # available.
      def self.included(base)
        if defined?(Config::Core) && defined?(Config::Core::Loggable)
          base.send :include, Config::Core::Loggable
        end
      end

      # Inject another log globally. This is used for testing.
      def self.impl=(mod); @impl = mod end
      def self.impl; @impl end

      # This method will be overridden if Config::Core::Loggable is included.
      # Otherwise look for the new implementation.
      def log
        if Loggable.impl
          Loggable.impl.log
        else
          raise "Logging is not configured. Config::Core::Loggable is required"
        end
      end
    end
  end
end
