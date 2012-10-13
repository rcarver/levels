module Config
  module Env
    module Loggable

      def self.included(base)
        if defined?(Config::Core) && defined?(Config::Core::Loggable)
          base.send :include, @impl
        end
      end

      def self.impl=(mod); @impl = mod end
      def self.impl; @impl end

      def log
        if impl
          impl.log
        else
          raise "Logging is not configured. Config::Core::Loggable is required"
        end
      end

    end
  end
end
