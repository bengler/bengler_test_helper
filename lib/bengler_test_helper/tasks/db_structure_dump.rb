require 'tempfile'

namespace :db do
  namespace :structure do
    desc 'Dump database schema to development_structure.sql'
    task :dump do
      config = BenglerTestHelper::ActiveRecord.database_configuration(ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development')
      abort "Database configuration must use localhost." unless %w(localhost 127.0.0.1).include?(config['host'])

      schema_file_name = 'db/development_structure.sql'
      Tempfile.open('schema') do |tempfile|
        tempfile.close
        unless system("pg_dump --format=p --schema-only --no-privileges -U '#{config['username']}' -f '#{tempfile.path}' '#{config['database']}'")
          abort "Failed to dump SQL."
        end
        old_data = File.read(schema_file_name) rescue nil
        new_data = File.read(tempfile.path)
        if old_data != new_data
          $stderr.puts "Dumping new schema to #{schema_file_name}."
          File.open(schema_file_name, 'w') { |file| file << new_data }
        else
          $stderr.puts "Scheme has not changed, not updating #{schema_file_name}."
        end
      end
    end
  end
end
