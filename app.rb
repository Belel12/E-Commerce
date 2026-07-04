require 'sinatra'
require 'sinatra/activerecord'
#importa todos os models existentes
Dir['./models/*.rb'].each { |file| require_relative file}

#define o ambiente/banco a ser usado
ENV['RACK_ENV'] ||= 'development'
class ECommerceApp < Sinatra::Base

  #define o caminho para procurar as migrations
  ActiveRecord::Migrator.migrations_paths = ["db/migrate"]

  #define conexao com o banco dependendo do ambiente
  # nao ta funcionando, o que define por enquanto ta
  # sendo o database.yml
  #set :database, { adapter: 'sqlite3', database: 'db/ecommerce.sqlite3' }
end


