require_relative 'support'

describe 'POST /adicionar_carrinho', type: :route do
  let!(:comprador) { usuario_valido('5') }
  let!(:vendedor) { usuario_valido('6') }
  let!(:produto) { produto_valido(vendedor, estoque: 5) }
  let!(:outro_produto) { produto_valido(vendedor, nome: 'Outro produto') }
  let(:parametros) { { id_usuario: comprador.id, id_produto: produto.id, quantidade: 1 } }

  context 'quando faltam parâmetros' do
    it 'responde 400' do
      post '/adicionar_carrinho', parametros.except(:quantidade)
      expect(last_response.status).to eq(400)
    end
  end

  context 'quando o produto não existe' do
    it 'responde 404' do
      post '/adicionar_carrinho', parametros.merge(id_produto: 0)
      expect(last_response.status).to eq(404)
    end
  end

  context 'quando o usuário não existe' do
    it 'responde 404' do
      post '/adicionar_carrinho', parametros.merge(id_usuario: 0)
      expect(last_response.status).to eq(404)
    end
  end

  context 'quando é um produto novo no carrinho' do
    it 'responde 201 e permite adicionar outro produto distinto' do
      post '/adicionar_carrinho', parametros
      expect(last_response.status).to eq(201)

      post '/adicionar_carrinho', parametros.merge(id_produto: outro_produto.id)
      expect(last_response.status).to eq(201)
      expect(ItemCarrinho.where(usuario: comprador).pluck(:produto_id)).to contain_exactly(produto.id, outro_produto.id)
    end
  end

  context 'quando o produto já está no carrinho' do
    let!(:item) { ItemCarrinho.create!(usuario: comprador, produto: produto, quantidade: 1) }

    it 'responde 200' do
      post '/adicionar_carrinho', parametros
      expect(last_response.status).to eq(200)
    end
  end

  context 'quando a quantidade é inválida' do
    it 'responde 422' do
      post '/adicionar_carrinho', parametros.merge(quantidade: produto.estoque + 1)
      expect(last_response.status).to eq(422)
    end
  end
end
