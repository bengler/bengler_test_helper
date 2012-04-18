namespace :db do
  namespace :test do

    desc 'Recreate test database from development_structure.sql'
    task :load_structure do
      config = BenglerTestHelper::ActiveRecord.database_configuration('test')
      unless %w(localhost 127.0.0.1).include?(config['host'])
        abort "Database configuration must use localhost."
      end

      database_name = config['database']
      user_name = config['username']

      found = false
      IO.popen(%(psql -ltA --no-psqlrc)) do |file|
        file.each_line do |line|
          found = true if line =~ /^#{Regexp.escape(database_name)}\|/
        end
      end
      if found
        unless system("dropdb '#{database_name}'")
          abort "Could not drop database #{database_name}"
        end
      end

      unless system("createdb -O '#{user_name}' #{database_name}")
        abort "Could not create database #{database_name}"
      end

      # Note that we load the schema using the current user, which must be a superuser,
      # because some schema elements such as base types and C functions may only be
      # created by a superuser
      schema_file_name = 'db/development_structure.sql'
      unless system("psql -1 -q -o /dev/null --no-psqlrc -d '#{database_name}' -f '#{schema_file_name}'")
        abort "Failed to load SQL from #{schema_file_name}. Ensure that your own Postgres user is a superuser."
      end

      $stderr.puts "Database #{database_name} loaded from #{schema_file_name}."
    end

  end

end