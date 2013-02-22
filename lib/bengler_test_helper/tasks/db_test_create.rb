namespace :db do
  namespace :test do
    desc 'Creates a test database.'
    task :create do
      config = BenglerTestHelper::ActiveRecord.database_configuration('test')
      abort 'Database configuration must use localhost.' unless %w(localhost 127.0.0.1).include?(config['host'])

      unless system("dropdb --if-exists '#{config['database']}'")
        abort "Could not drop database '#{config['database']}'"
      end

      unless system("psql -tA postgres -c '\du' | grep -E '^#{config['username']}|' >/dev/null")
        unless system("createuser -s '#{config['username']}'")
          abort "Could not create database user '#{config['username']}'"
        end
      end

      unless system("createdb -O '#{config['username']}' '#{config['database']}'")
        abort "Could not create database '#{config['database']}'"
      end
    end
  end
end
