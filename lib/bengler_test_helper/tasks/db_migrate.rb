namespace :db do
  Rake::Task['migrate'].enhance do
    Rake::Task['db:structure:dump'].invoke if ENV['RACK_ENV'] == 'development'
  end
end
