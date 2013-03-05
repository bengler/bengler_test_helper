namespace :db do
  namespace :test do
    desc 'Sets up a database config file.'
    task :config do
      require 'bundler'
      b = Bundler.setup
      name = File.basename(`git config --get remote.origin.url`.strip, '.git')
      File.open('config/database.yml', 'w') do |f|
        f.write <<-end
test:
  adapter: #{b.gems['activerecord-postgis-adapter'].empty? ? 'postgresql' : 'postgis'}
  host: localhost
  database: #{name}_test
  username: #{name}
  password: #{(0...8).map{(97+rand(26)).chr}.join}
  encoding: unicode
end
      end
    end
  end
end
