namespace :db do
  namespace :test do

    desc 'Recreate test database from development_structure.sql'
    task :load_structure do
      config = BenglerTestHelper::ActiveRecord.database_configuration
      unless %w(localhost 127.0.0.1).include?(config['host'])
        abort "Database configuration must use localhost."
      end

      database_name = config['database']
      user_name = config['username']

      found = false
      IO.popen(%(psql -U '#{user_name}' -ltA --no-psqlrc)) do |file|
        file.each_line do |line|
          found = true if line =~ /^#{Regexp.escape(database_name)}\|/
        end
      end
      if found
        $stderr.puts "Dropping database"
        system("dropdb -U '#{user_name}' '#{database_name}'")
      end

      $stderr.puts "Creating database"
      unless system("createdb -U '#{user_name}' -O '#{user_name}' #{database_name}")
        abort "Could not create database #{database_name}"
      end

      $stderr.puts "Loading schema"
      schema_file_name = 'db/development_structure.sql'
      unless system("psql -U '#{user_name}' -q -o /dev/null --no-psqlrc -d '#{database_name}' -f '#{schema_file_name}'")
        abort "Failed to load SQL from #{schema_file_name}."
      end
    end

  end

end