require 'json'

describe 'Fluxo de compra pela interface', type: :route do
  def app
    ECommerceApp
  end

  let(:senha) { 'senha-segura' }
  let(:vendedor_params) do
    {
      nome: 'Vendedor', email: 'vendedor@example.com', cpf: '12345678901',
      senha: senha, confirmar_senha: senha
    }
  end
  let(:comprador_params) do
    {
      nome: 'Comprador', email: 'comprador@example.com', cpf: '10987654321',
      senha: senha, confirmar_senha: senha
    }
  end

  def cadastrar_e_autenticar(parametros)
    post '/cadastro', parametros
    expect(last_response.status).to eq(201)

    post '/login', email: parametros[:email], senha: parametros[:senha]
    expect(last_response.status).to eq(200)

    JSON.parse(last_response.body).fetch('user_id')
  end

  def alterar_status(venda, usuario, novo_status)
    put '/alterar_status_venda',
        { id_venda: venda.id, id_usuario: usuario, novo_status: novo_status }.to_json,
        'CONTENT_TYPE' => 'application/json'
  end

  context 'quando vendedor e comprador concluem uma venda' do
    it 'cadastra usuários, publica, compra, paga, envia e entrega o produto' do
      id_vendedor = cadastrar_e_autenticar(vendedor_params)
      id_comprador = cadastrar_e_autenticar(comprador_params)

      post '/produtos',
           { id_usuario: id_vendedor, nome: 'Notebook', descricao: 'Notebook seminovo', preco: 2500, estoque: 2 },
           'HTTP_REFERER' => "/produtos?id_usuario=#{id_vendedor}"
      expect(last_response.status).to eq(302)

      produto = Produto.find_by!(nome: 'Notebook', usuario_id: id_vendedor)
      post '/comprar', id_usuario: id_comprador, id_produto: produto.id, quantidade: 1
      expect(last_response.status).to eq(200)

      venda = Venda.find_by!(comprador_id: id_comprador, vendedor_id: id_vendedor)
      expect(venda.status).to eq('pendente')

      alterar_status(venda, id_comprador, 'paga')
      expect(last_response.status).to eq(200)

      alterar_status(venda, id_vendedor, 'enviada')
      expect(last_response.status).to eq(200)

      alterar_status(venda, id_vendedor, 'entregue')
      expect(last_response.status).to eq(200)
      expect(venda.reload.status).to eq('entregue')
    end
  end
end
