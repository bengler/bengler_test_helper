namespace :db do
  namespace :test do
    desc 'Prepare database for running tests.'
    task :prepare do
      Rake::Task['db:test:create'].invoke unless ENV['SEMAPHORE']
      Rake::Task['db:structure:load'].invoke

      bootstrap_file_name = File.expand_path('db/bootstrap.sql', '.')
      if File.exist?(bootstrap_file_name)
        config = BenglerTestHelper::ActiveRecord.database_configuration('test')
        unless system("psql -U #{ENV['USER']} -q -o /dev/null --no-psqlrc " \
          "-d '#{config['database']}' -f '#{bootstrap_file_name}'")
          abort "Failed to load SQL from #{bootstrap_file_name}."
        end
        $stderr.puts "Loaded bootstrap data from #{bootstrap_file_name}."
      end
    end
  end
end
