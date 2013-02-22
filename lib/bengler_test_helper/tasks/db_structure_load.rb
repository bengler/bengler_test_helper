namespace :db do
  namespace :test do
    desc 'Recreate test database from development_structure.sql'
    task :load_structure do
      config = BenglerTestHelper::ActiveRecord.database_configuration('test')
      abort 'Database configuration must use localhost.' unless %w(localhost 127.0.0.1).include?(config['host'])

      found = false
      IO.popen(%(psql -ltA --no-psqlrc)) do |file|
        file.each_line do |line|
          found = true if line =~ /^#{Regexp.escape(config['database'])}\|/
        end
      end
      if found
        unless system("dropdb '#{config['database']}'")
          abort "Could not drop database #{config['database']}"
        end
      end

      unless system("createdb -O '#{config['username']}' #{config['database']}")
        abort "Could not create database #{config['database']}"
      end

      schema_file_name = 'db/development_structure.sql'
      unless system("psql -1 -q -o /dev/null --no-psqlrc -d '#{config['database']}' -f '#{schema_file_name}'")
        abort "Failed to load SQL from #{schema_file_name}. Ensure that your own Postgres user is a superuser."
      end

      $stderr.puts "Database #{config['database']} loaded from #{schema_file_name}."
    end
  end
end
