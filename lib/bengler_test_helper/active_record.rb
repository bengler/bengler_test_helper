module BenglerTestHelper
  module ActiveRecord

    class << self
      def database_configuration(environment)
        require 'active_record'
        config = YAML.load(File.open('config/database.yml'))
        ::ActiveRecord::Base.configurations = config
        config = config[environment] # can't fetch from ActiveRecord due to bug
        raise "No database configuration for environment #{environment.inspect}." unless config
        config
      end
    end

  end
end
