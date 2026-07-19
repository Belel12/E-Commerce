# frozen_string_literal: true

require_relative 'support'

describe 'POST /comprar', type: :route do
  let!(:comprador) { usuario_valido('10') }
  let!(:vendedor) { usuario_valido('11') }
  let!(:produto) { produto_valido(vendedor) }
  let(:parametros) { { id_usuario: comprador.id, id_produto: produto.id, quantidade: 1 } }

  context 'quando a compra é válida' do
    it 'responde 200' do
      post '/comprar', parametros
      expect(last_response.status).to eq(200)
    end
  end

  context 'quando o comprador não existe' do
    it 'responde 404' do
      post '/comprar', parametros.merge(id_usuario: 0)
      expect(last_response.status).to eq(404)
    end
  end

  context 'quando os parâmetros de produto estão em excesso' do
    it 'responde 400' do
      post '/comprar', parametros.merge(ids_produto: [produto.id])
      expect(last_response.status).to eq(400)
    end
  end

  context 'quando os parâmetros de quantidade estão em excesso' do
    it 'responde 400' do
      post '/comprar', parametros.merge(quantidade_produtos: [1])
      expect(last_response.status).to eq(400)
    end
  end

  context 'quando falta o id do produto' do
    it 'responde 400' do
      post '/comprar', parametros.except(:id_produto)
      expect(last_response.status).to eq(400)
    end
  end

  context 'quando falta a quantidade' do
    it 'responde 400' do
      post '/comprar', parametros.except(:quantidade)
      expect(last_response.status).to eq(400)
    end
  end

  context 'quando há quantidades e produtos em números diferentes' do
    it 'responde 400' do
      post '/comprar', id_usuario: comprador.id, ids_produto: [produto.id, produto.id], quantidade_produtos: [1]
      expect(last_response.status).to eq(400)
    end
  end
end
