# frozen_string_literal: true

require_relative 'support'

describe 'GET /produto', type: :route do
  let!(:vendedor) { usuario_valido('4') }
  let!(:produto) { produto_valido(vendedor) }

  context 'quando o produto existe' do
    it 'responde 200' do
      get '/produto', id_produto: produto.id, id_usuario: ''
      expect(last_response.status).to eq(200)
    end
  end

  context 'quando o produto não existe' do
    it 'responde 404' do
      get '/produto', id_produto: 0, id_usuario: ''
      expect(last_response.status).to eq(404)
    end
  end
end
