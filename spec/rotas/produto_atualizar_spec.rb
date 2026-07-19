# frozen_string_literal: true

require_relative 'support'

describe 'POST /produtos/:id', type: :route do
  let!(:usuario) { usuario_valido('25') }
  let!(:produto) { produto_valido(usuario) }
  let(:parametros) { { id_usuario: usuario.id, nome: 'Produto alterado', preco: 20, estoque: 2 } }

  context 'quando faltam parâmetros' do
    it 'responde 400' do
      post "/produtos/#{produto.id}", parametros.except(:nome)
      expect(last_response.status).to eq(400)
    end
  end

  context 'quando o usuário não existe' do
    it 'responde 404' do
      post "/produtos/#{produto.id}", parametros.merge(id_usuario: 0)
      expect(last_response.status).to eq(404)
    end
  end

  context 'quando o produto não pertence ao usuário' do
    it 'responde 404' do
      post '/produtos/0', parametros
      expect(last_response.status).to eq(404)
    end
  end

  context 'quando os novos dados são inválidos' do
    it 'responde 422' do
      post "/produtos/#{produto.id}", parametros.merge(preco: -1)
      expect(last_response.status).to eq(422)
    end
  end

  context 'quando os novos dados são válidos' do
    it 'responde 302' do
      post "/produtos/#{produto.id}", parametros
      expect(last_response.status).to eq(302)
    end
  end
end
