namespace :db do
  namespace :structure do
    desc 'Recreate test database from development_structure.sql'
    task :load do
      default_config = BenglerTestHelper::ActiveRecord.database_configuration
      test_config = BenglerTestHelper::ActiveRecord.database_configuration('test')

      unless %w(localhost 127.0.0.1).include?(test_config['host'])
        abort 'Database configuration must use localhost.'
      end
      if default_config['username'] != test_config['username']
        $stderr.puts "Warning: Test database user is different from development database user."
        $stderr.puts "  This may cause schema ownership issues."
      end

      schema_file_name = 'db/development_structure.sql'
      unless system("psql -1 -q -o /dev/null --no-psqlrc " \
        "-v ON_ERROR_ROLLBACK=off -v ON_ERROR_STOP=on " \
        "-d '#{test_config['database']}' -f '#{schema_file_name}'")
        abort "Failed to load SQL from #{schema_file_name}. Ensure that your own Postgres user is a superuser."
      end

      $stderr.puts "Database #{test_config['database']} loaded from #{schema_file_name}."
    end
  end
end
