namespace :db do
  namespace :test do
    desc 'Sets up a database config file.'
    task :config, :name do |t, args|
      name = args[:name] || File.basename(Dir.pwd)
      File.write('config/database.yml', <<-end
test:
  adapter: postgresql
  host: localhost
  database: #{name}_test
  username: #{name}
  password:
  encoding: unicode
end
      )
    end
  end
end
