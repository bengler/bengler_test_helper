module BenglerTestHelper
  module ActiveRecord

    class << self
      def database_configuration(environment)
        require 'active_record'
        config = YAML.load(File.open('config/database.yml'))
        envconfig = config[environment] and config[environment].clone
        ::ActiveRecord::Base.configurations = config
        raise "No database configuration for environment #{environment.inspect}." unless envconfig
        envconfig
      end
    end

  end
end
