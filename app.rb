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
    @produtos = Produto.where.not(usuario: params[:id_usuario])
                .where(estoque: 1..)
    if params[:busca].present?
      busca = ActiveRecord::Base.sanitize_sql_like(params[:busca])
      @produtos = @produtos.where("nome LIKE ?","%#{busca}%")
    end
    erb :tela_inicial
  end

  #ROTA PARA TELA DE CADASTRO
  get '/cadastro' do
    status 200
    erb :cadastro
  end

  #ROTA PARA PROCESSAR REQUISIÇÃO DE CADASTRO
  post '/cadastro' do
    content_type :json
    if params[:senha] != params[:confirmar_senha]
      halt 422, {message: 'Senhas são diferentes'}.to_json
    end
    novo_usuario = Usuario.new(
      nome: params[:nome].strip,
      email: params[:email].strip,
      senha_hash: params[:senha].strip,
      cpf: params[:cpf].strip,
      telefone: params[:telefone]
    )

    if novo_usuario.save
      #redirect '/login?cadastro_redirect=true'
      halt 201,{message: 'Usuário cadastrado com sucesso'}.to_json
    else
      halt 422,{
        message: 'Usuário inválido',
        erros: novo_usuario.errors.full_messages,
      }.to_json
    end
  end
  # ROTA PARA A TELA DO LOGIN
  get '/login' do
    status 200
    @usuario_recem_cadastrado = params[:cadastro_redirect]
    erb :login
  end

  #ROTA PARA PROCESSAMENTO DA REQUISIÇÃO
  # DO LOGIN
  post '/login' do
    content_type :json
    user = Usuario.find_by(email: params[:email].strip)
    if user
      if user.senha_hash == Digest::MD5.hexdigest(params[:senha].strip)
        halt 200, {user_id: user.id}.to_json
      else
        halt 422, {message: 'Senha inválida'}.to_json
      end
    else
      halt 404, {message: 'Email não cadastrado'}.to_json
    end
  end

  #ROTAS DE PRODUTO
  # ROTA PARA ACESSAR A PAGINA DE UM PRODUTO ESPECIFICO
  get '/produto' do
    @produto = Produto.find_by(id: params[:id_produto])
    if @produto.nil?
      halt 404, 'PRODUTO NAO ENCONTRADO'
    end
    @id_usuario = params[:id_usuario].empty?? nil : params[:id_usuario]
    erb :produto_inspect
  end

  #ROTA DE ADICIONAR AO CARRINHO
  post '/adicionar_carrinho' do
    content_type :json
    unless params[:id_usuario].present? && params[:id_produto].present? && params[:quantidade].present?
      halt 400, {message: 'Parâmetros faltando'}.to_json
    end
    produto = Produto.find_by(id: params[:id_produto])
    if produto.nil?
      halt 404, {message: 'Produto não encontrado'}.to_json
    end

    usuario = Usuario.find_by(id: params[:id_usuario])
    if usuario.nil?
      halt 404, {message: 'Usuário não encontrado'}.to_json
    end
    novo_item = ItemCarrinho.find_or_initialize_by(
      usuario: usuario,
      produto: produto
    )
    if !novo_item.persisted?
      criado = true
      novo_item.quantidade = params[:quantidade]
    else
      criado = false
      novo_item.quantidade = [novo_item.quantidade+params[:quantidade].to_i,produto.estoque].min
    end
    if novo_item.save
      if criado
        halt 201, {message: 'Item adicionado ao carrinho com sucesso'}.to_json
      else
        halt 200, {message: 'Item atualizado no carrinho com sucesso'}.to_json
      end
    else
      halt 422, {message: 'Erro ao adicionar item ao carrinho', erros: novo_item.errors.full_messages}.to_json
    end
  end

  #ROTA DO CARRINHO
  get '/carrinho' do
    usuario = Usuario.find_by(id: params[:id_usuario])
    if usuario.nil?
      halt 404, 'USUARIO NAO ENCONTRADO'
    end
    status 200
    @id_usuario = usuario&.id
    @itens_carrinho_usuario = usuario&.produtos_carrinho&.includes(:produto)
    erb :carrinho
  end

  #ROTA PARA REMOVER ITEM DO CARRINHO
  delete '/remover_item_carrinho' do
    content_type :json
    item = ItemCarrinho.find_by(id: params[:id_item])
    if item.nil?
      halt 404, {message: 'Item não encontrado'}.to_json
    end
    if item.destroy.destroyed?
      halt 204, {message: 'Item deletado com sucesso'}.to_json
    else
      halt 422, {message: 'Erro ao apagar item',erros: item.errors.full_messages}.to_json
    end
  end

  #ROTA PARA REALIZAR COMPRA -> CRIAR VENDA
  post '/comprar' do
    comprador = Usuario.find_by(id: params[:id_usuario])
    if comprador.nil?
      halt 404, 'COMPRADOR NAO ENCONTRADO'
    end

    if params[:id_produto] and params[:ids_produto]
      halt 400, 'PARÂMETROS ID EM EXCESSO'
    end

    if params[:quantidade] and params[:quantidade_produtos]
      halt 400, 'PARÂMETROS QUANTIDADE EM EXCESSO'
    end

    quantidade_s = Array(params[:quantidade] || params[:quantidade_produtos])

    produto_s = Array(params[:id_produto] || params[:ids_produto])
    if produto_s.nil? || produto_s.empty?
      halt 400, 'ID(s) DE PRODUTO FALTANDO'
    end

    if quantidade_s.nil? || quantidade_s.empty?
      halt 400, 'QUANTIDADE FALTANDO'
    end

    if quantidade_s&.length != produto_s&.length
      halt 400, 'QUANTIDADE DE IDS DIFERENTE DA DE QUANTIDADES'
    end
    produto_s = Produto
                  .includes(:usuario)
                  .where(id: produto_s)
                  .group_by { |produto| produto.usuario}
    if produto_s.nil?
      halt 404, 'NENHUM PRODUTO ENCONTRADO PARA O(s) ID(s) PASSADOS'
    end
    i = -1
    produto_s&.each do |vendedor, produtos|
      i+=1
      nova_venda = Venda.new(
        comprador: comprador,
        vendedor: vendedor,
        data: Date.today,
        status: 'pendente',
        valor_total: 0
      )
      unless nova_venda.save
        halt 422, nova_venda.errors.full_messages.join(', ')
      end
      produtos.each do |produto|
        #se o item nao for salvo devido algum erro,
        # ele será simplesmente ignorado
        ItemVenda.create(
          venda: nova_venda,
          produto: produto,
          preco_unitario: produto.preco,
          quantidade: quantidade_s[i]
        )
      end
    end
    comprador&.produtos_carrinho&.destroy_all
    halt 200, 'COMPRA FINALIZADA COM SUCESSO, PAGAMENTO PENDENTE'
  end

  #ROTA PARA PERFIL
  get '/perfil' do
    if params[:message] and !params[:message].blank?
      case params[:message]
      when 'dados'
        @message = 'Dados atualizados com sucesso!'
      when 'senha'
        @message = 'Senha alterada com sucesso!'
      when 'erro_senha_atual'
        @message = "ERRO\nSENHA ATUAL INCORRETA"
      when 'erro_senhas_diferentes'
        @message = "ERRO\nSENHAS DIFERENTES"
      else
        @message = nil
      end
    end
    @usuario = Usuario.find_by(id: params[:id_usuario])
    if @usuario.nil?
      halt 404, 'USUARIO NÃO ENCONTRADO'
    end
    @id_usuario = @usuario&.id #apenas para o layout mostrar a nav_bar correta
    status 200
    erb :perfil
  end

  #ROTA PARA ACESSAR O PERFIL
  # PODENDO VISUALIZAR E EDITAR DADOS E SENHA
  post '/perfil' do
    content_type :json
    unless params[:tipo_alteracao].present?
      halt 400, {message: 'Tipo de alteração não definida'}.to_json
    end
    usuario = Usuario.find_by(id: params[:id_usuario])
    if usuario.nil?
      halt 404,{message: 'USUÁRIO NÃO ENCONTRADO'}.to_json
    end
    if params[:tipo_alteracao] == 'dados_conta'
      usuario.nome = params[:nome]
      usuario.cpf = params[:cpf]
      usuario.telefone = params[:telefone]
      if usuario.save
        halt 200, {message: 'Usuário alterado com sucesso'}.to_json
      else
        halt 422, {message: 'Erro ao salvar usuário',erros: usuario.errors.full_messages}.to_json
      end
    elsif params[:tipo_alteracao] == 'alterar_senha'
      if Digest::MD5.hexdigest(params[:senha_atual]) != usuario.senha_hash
        halt 422,{message: 'Senha atual incorreta'}.to_json
      elsif params[:nova_senha] != params[:confirmar_nova_senha]
        halt 422, {message: 'Senhas são diferentes'}.to_json
      end
      usuario.senha_hash = params[:nova_senha]
      if usuario.save
        halt 200,{message: 'Senha alterada com sucesso'}.to_json
      else
        halt 422, {
          message: 'Erro ao salvar nova senha',
          erros: usuario.errors.full_messages
        }.to_json
      end
    end
  end

  #ROTA PARA VISUALIZAR COMPRAS DO USUARIO
  get '/compras' do
    unless params[:id_usuario].present?
      @message='ERRO AO PROCURAR COMRPAS, USUÁRIO FALTANDO'
      @previous_url = request.referer
      status 400
      erb :error_screen
    end
    @id_usuario = params[:id_usuario]
    @compras = Venda.where(comprador: params[:id_usuario]).includes(:vendedor).order(id: :desc)
    status 200
    erb :compras_usuario
  end

  #ROTA PARA VISUALIZAR OS ITENS DE UMA VENDA
  get '/itens_venda' do
    @previous_url = request.referer
    unless params[:id_venda].present?
      @message = 'ID DA VENDA FALTANDO'
      status 400
      erb :error_screen
    end
    @venda = Venda.find_by(id: params[:id_venda])
    if @venda.nil?
      @message = 'VENDA NÃO ENCONTRADA'
      status 404
      erb :error_screen
    end
    @itens_venda = ItemVenda.where(venda: @venda).includes(:produto)
    if @itens_venda.nil?
      status 404
      @message = 'VENDA SEM ITENS ASSOCIADOS'
      erb :error_screen
    end
    @id_usuario = params[:id_usuario]
    @url_voltar = request.referer
    erb :itens_venda
  end

  #ROTA DE API PARA VALIDAR A SENHA
  # DO USUARIO ANTES DE ALGUMA OPERAÇÃO
  get '/verificar_senha' do
    content_type :json
    halt 400, {message: 'parametros incorretos'}.to_json unless params[:id_usuario].present? && params[:senha].present?
    usuario = Usuario.find_by(id: params[:id_usuario])
    halt  404, {message: 'usuario nao encontrado'}.to_json unless usuario
    verificacao = Digest::MD5.hexdigest(params[:senha].strip) == usuario&.senha_hash
    {verificacao: verificacao}.to_json
  end

  #ROTA DE API PARA ALTERAR O STATUS DE UMA VENDA,
  # SEJA POR PARTE DO COMPRADOR OU DO VENDEDOR
  put '/alterar_status_venda' do
    dados = JSON.parse(request.body.read)
    parametros_corretos = dados['id_venda'].present? && dados['novo_status'].present? && dados['id_usuario'].present?
    halt 400, 'PARAMETROS INCORRETOS' unless parametros_corretos
    usuario = Usuario.select(:id).find_by(id: dados['id_usuario'])
    halt 404, 'USUARIO NÃO ENCONTRADO' if usuario.nil?
    venda = Venda.find_by(id: dados['id_venda'])
    halt 404, 'VENDA NÃO ENCONTRADA' if venda.nil?
    if venda&.vendedor_id == usuario&.id
      status_options = %i[enviada entregue]
    elsif venda&.comprador_id == usuario&.id
      status_options = %i[paga cancelada]
    else
      status_options == nil
    end
    halt 400, 'INCOMPATIBILIDADE ENTRE VENDA E USUÁRIO' if status_options.nil?
    if status_options&.include?(dados['novo_status'].to_sym)
      begin
        venda.update(status: dados['novo_status'].to_sym)
        halt 200, 'STATUS ALTERADO COM SUCESSO'
      rescue SemEstoqueError => e
        content_type :json
        halt 422, {
          message: 'Produtos sem estoque',
          error_type: 'sem_estoque',
          itens_id: e.itens_inconsistentes.map {|item| item.id}
        }.to_json
      rescue ProdutoApagadoError => e
        #apaga todos os itens que possuem produtos apagados
        e.itens_produtos_apagados.delete_all
        # apaga a venda se tiver ficado sem itens
        unless venda.itens_venda.exists?
          venda.destroy
        end
        content_type :json
        halt 422, {
          message: 'Produtos sem estoque',
          error_type: 'produto_apagado',
        }.to_json
      end
    else
      halt 403, 'ACESSO NÃO AUTORIZADO OU STATUS INVÁLIDO'
    end
  end

  #ROTA DE API PARA DELETAR ITENS DE UMA VENDA PASSANDO OS IDs COMO PARÂMETRO
  delete '/itens_venda' do
    content_type :json
    unless params[:id_itens].present?
      halt 400, {message: 'id_vendas faltando'}.to_json
    end
    itens = ItemVenda.where(id: params[:id_itens])
    if itens.empty?
      halt 400, {message: 'nenhum item encontrado para os ids passados'}.to_json
    end
    venda_associada = itens.first.venda
    itens.destroy_all
    unless venda_associada.itens_venda.exists?
      venda_associada.destroy
    end
    halt 204, {message: 'Itens apagados'}.to_json
  end

  #ROTA PARA ACESSAR OS PRODUTOS DO USUÁRIO
  get '/produtos' do
    @usuario = Usuario.find_by(id: params[:id_usuario])
    halt 404, 'USUARIO NAO ENCONTRADO' unless @usuario

    @id_usuario = @usuario.id
    @produtos = @usuario.produtos.order(:nome)
    @produto = Produto.new
    erb :produtos
  end

  #ROTA PARA CADASTRAR PRODUTO
  post '/produtos' do
    unless params[:nome].present? && params[:preco].present? && params[:estoque].present?
      halt 400, 'PARÂMETROS FALTANDO'
    end
    usuario = Usuario.find_by(id: params[:id_usuario])
    halt 404, 'USUARIO NAO ENCONTRADO' unless usuario

    produto = usuario.produtos.new(
      nome: params[:nome],
      descricao: params[:descricao],
      preco: params[:preco],
      estoque: params[:estoque]
    )

    if produto.save
      redirect back
    else
      @previous_url = request.referer
      status 422
      erb :error_screen
    end
  end

  #ROTA PARA ACESSAR A TELA DE UM PRODUTO ESPECIFICO
  post '/produtos/:id' do
    unless params[:nome].present? && params[:preco].present? && params[:estoque].present?
      halt 400, 'PARÂMETROS FALTANDO'
    end

    usuario = Usuario.find_by(id: params[:id_usuario])
    halt 404, 'USUARIO NAO ENCONTRADO' unless usuario

    produto = usuario.produtos.find_by(id: params[:id])
    halt 404, 'PRODUTO NAO ENCONTRADO' unless produto


    halt 422, produto.errors.full_messages.join(', ') unless produto.update(
      nome: params[:nome],
      descricao: params[:descricao],
      preco: params[:preco],
      estoque: params[:estoque]
    )
    redirect back
  end

  #ROTA PARA EXCLUIR UM PRODUTO
  post '/produtos/:id/excluir' do
    usuario = Usuario.find_by(id: params[:id_usuario])
    halt 404, 'USUARIO NAO ENCONTRADO' unless usuario

    produto = usuario.produtos.find_by(id: params[:id])
    halt 404, 'PRODUTO NAO ENCONTRADO' unless produto

    produto.destroy!
    redirect back
  end

  #ROTA PARA EXIBIR AS VENDAS DO USUÁRIO
  get '/vendas' do
    usuario = Usuario.find_by(id: params[:id_usuario])
    unless usuario
      status 404
      @previous_url = request.referer
      erb :error_screen
    end

    @id_usuario = usuario.id
    @vendas = usuario.vendas.includes(:comprador).order(data: :desc)
    erb :vendas_usuario
  end
end


