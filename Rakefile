require_relative 'app'
require 'sinatra/activerecord/rake'


task :ola do
  puts('Ola Mundo')
end

namespace :db do
  task :migrate_test do
    system('RACK_ENV=test rake db:migrate')
  end
end
