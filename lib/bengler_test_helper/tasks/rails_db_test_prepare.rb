namespace :db do
  namespace :test do

    Rake.application.remove_task :"db:test:prepare"

    task :prepare => ['db:test:load_structure'] do
    end

  end

end