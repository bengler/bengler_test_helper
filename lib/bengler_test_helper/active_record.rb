module BenglerTestHelper
  module ActiveRecord

    class << self
      def database_configuration(environment)
        require 'active_record'
        ::ActiveRecord::Base.configurations = YAML.load(File.open('config/database.yml'))

        config = ::ActiveRecord::Base.configurations[environment]
        unless config
          raise "No database configuration for environment #{environment.inspect}."
        end
        config
      end
    end

  end
end