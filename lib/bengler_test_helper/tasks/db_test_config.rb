namespace :db do
  namespace :test do
    desc 'Sets up a database config file.'
    task :config do
      name = File.basename(`git config --get remote.origin.url`.strip, '.git')
      File.write('config/database.yml', <<-end
test:
  adapter: postgresql
  host: localhost
  database: #{name}_test
  username: #{name}
  password: #{(0...8).map{(97+rand(26)).chr}.join}
  encoding: unicode
end
      )
    end
  end
end
