require 'sinatra'
require 'sinatra/base'
require 'sinatra/activerecord'

Dir['./models/*.rb'].each { |file| require file}

ENV["AMBIENTE"] = 'desenvolvimento'
class ECommerceApp < Sinatra::Base
  DB_DIR = "#{__dir__}/db"

  #define o caminho para procurar as migrations
  ActiveRecord::Migrator.migrations_paths = [DB_DIR+"/migrate"]

  #define conexao com o banco dependendo do ambiente
  set :database, {
    adapter: 'sqlite3',
    database: DB_DIR+"/ecommerce_#{ENV["AMVBIENTE"] || 'desenvolvimento'}.sqlite3"
  }

end


