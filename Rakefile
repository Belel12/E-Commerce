# frozen_string_literal: true

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

task :build do
  if ENV['RACK_ENV'] == 'development'
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:migrate_test'].invoke # migração do banco de teste
  elsif ENV['RACK_ENV'] == 'production'
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
  else
    puts "\n\nAMBIENTE DE CONSTRUÇÃO #{ENV['RACK_ENV']} NÃO RECONHECIDO"
  end
end
