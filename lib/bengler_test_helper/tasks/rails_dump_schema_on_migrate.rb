namespace :db do

  Rake::Task['migrate'].enhance do
    Rake::Task['db:structure:dump'].invoke
  end

end
