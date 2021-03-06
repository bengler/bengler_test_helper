namespace :db do
  namespace :structure do
    desc 'Dump database schema to development_structure.sql'
    task :dump do
      config = BenglerTestHelper::ActiveRecord.database_configuration(ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development')
      abort "Database configuration must use localhost." unless %w(localhost 127.0.0.1).include?(config['host'])

      schema = ''
      IO.popen(%{
        pg_dump --format=p --schema-only --no-privileges #{config['database']}
      }.strip, 'r') do |out|
        out.each_line do |line|
          # Note: This filters out "COMMENT ON EXTENSION" etc., which cannot
          # be restored by a non-superuser due to a bug (#8695) in PostgreSQL.
          if line !~ /^COMMENT ON /
            schema << line
          end
        end
      end
      if $?.exitstatus != 0
        abort "Failed to dump SQL."
      end

      schema_file_name = 'db/development_structure.sql'

      previous_schema = File.read(schema_file_name) rescue nil
      if previous_schema != schema
        $stderr.puts "Dumping new schema to #{schema_file_name}."
        File.open(schema_file_name, 'w') { |file| file << schema }
      else
        $stderr.puts "Scheme has not changed, not updating #{schema_file_name}."
      end
    end
  end
end
