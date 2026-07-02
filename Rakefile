# frozen_string_literal: true

require 'sinatra/activerecord/rake'

task :ola do
  puts('Ola Mundo')
end

namespace :run do
  task :development do
    ENV["AMBIENTE"] = 'desenvolvimento'
    system 'bundle exec rackup'
  end

  task :production do
    ENV["AMBIENTE"] = 'producao'
    system 'bundle exec rackup'
  end

end