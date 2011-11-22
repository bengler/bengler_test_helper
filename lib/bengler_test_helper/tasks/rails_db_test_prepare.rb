namespace :db do
  namespace :test do

    desc 'Prepare database for running tests.'
    task :prepare => ['db:test:load_structure'] do
    end

  end

end