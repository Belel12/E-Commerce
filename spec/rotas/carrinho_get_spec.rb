# frozen_string_literal: true

require_relative 'support'

describe 'GET /carrinho', type: :route do
  let!(:usuario) { usuario_valido('7') }

  context 'quando o usuário existe' do
    it 'responde 200' do
      get '/carrinho', id_usuario: usuario.id
      expect(last_response.status).to eq(200)
    end
  end

  context 'quando o usuário não existe' do
    it 'responde 404' do
      get '/carrinho', id_usuario: 0
      expect(last_response.status).to eq(404)
    end
  end
end
