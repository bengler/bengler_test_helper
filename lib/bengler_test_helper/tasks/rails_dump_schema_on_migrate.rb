namespace :db do

  Rake::Task['migrate'].enhance do
    $stderr.puts "Dumping updated schema to db/development_structure.sql"
    Rake::Task['db:structure:dump'].invoke
  end

end
