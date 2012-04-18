namespace :db do
  namespace :test do

    desc 'Load bootstrap data from db/bootstrap.sql'
    task :load_bootstrap do
      bootstrap_file_name = File.expand_path('db/bootstrap.sql', '.')
      if File.exist?(bootstrap_file_name)
        config = BenglerTestHelper::ActiveRecord.database_configuration('test')
        database_name = config['database']
        user_name = config['username']
        unless system("psql -U '#{user_name}' -q -o /dev/null --no-psqlrc -d '#{database_name}' -f '#{bootstrap_file_name}'")
          abort "Failed to load SQL from #{bootstrap_file_name}."
        end
        $stderr.puts "Loaded bootstrap data from #{bootstrap_file_name}."
      end
    end

    Rake::Task['prepare'].enhance do
      Rake::Task['db:test:load_bootstrap'].invoke
    end

  end

end
