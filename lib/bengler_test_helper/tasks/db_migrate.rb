namespace :db do
  Rake::Task['migrate'].enhance do
    Rake::Task['db:structure:dump'].invoke unless ['production', 'staging', 'test'].include?(ENV['RACK_ENV'])
  end
end
