namespace :db do
  Rake::Task['migrate'].enhance do
    Rake::Task['db:structure:dump'].invoke unless ENV['RACK_ENV'] == 'development'
  end
end
