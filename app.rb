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
  set :database, "db/ecommerce_#{ENV['RACK_ENV'] || 'development'}.sqlite3"
  set :adapter, :sqlite3

  #ROTA DA PAGINA INICIAL
  get '/' do
    status 200
    @id_usuario = params[:id_usuario]
    #PEGA TODOS OS PRODUTOS QUE N PERTENCAM AQUELE USUARIO
    # CASO O USUARIO N TIVER LOGADO, APARECERA TUDO
    @produtos = Produto.where.not(usuario: params[:id_usuario]).to_a
    erb :tela_inicial
  end

  #ROTAS DE CADASTRO E LOGIN
  #TODO: adicionar input hidden para token de validacao basica em login e cadastro
  #TODO: adicionar js na tela de cadastro e login para customizar as mensagems do
  # navegador de invalidacao dos dados
  get '/cadastro' do
    status 200
    erb :cadastro
  end

  post '/cadastro' do
    @erros = []
    @auto_complete=params
    if params[:senha] != params[:confirmar_senha]
      @erros << 'SENHAS NAO SAO IGUAIS'
    end
    novo_usuario = Usuario.new(
      nome: params[:nome].strip,
      email: params[:email].strip,
      senha_hash: params[:senha].strip,
      cpf: params[:cpf].strip
    )

    if novo_usuario.valid? and @erros.empty?
      novo_usuario.save
      redirect '/login?cadastro_redirect=true'
    else
      status 422
      @erros = @erros.concat novo_usuario.errors.full_messages.map {|error| error.upcase}
      erb :cadastro
    end
  end

  get '/login' do
    status 200
    @usuario_recem_cadastrado = params[:cadastro_redirect]
    erb :login
  end

  post '/login' do
    user = Usuario.find_by(email: params[:email].strip)
    if user
      if user.senha_hash == Digest::MD5.hexdigest(params[:senha].strip)
        status 200
        redirect "/?id_usuario=#{user.id}"
      else
        status 401
        @erro = 'SENHA INCORRETA, TENTE NOVAMENTE'
        erb :login
      end
    else
      status 404
      @erro = 'EMAIL NAO CADASTRADO'
      erb :login
    end
  end
end


