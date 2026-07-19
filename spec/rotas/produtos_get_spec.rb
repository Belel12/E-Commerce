# frozen_string_literal: true

require_relative 'support'

describe 'GET /produtos', type: :route do
  let!(:usuario) { usuario_valido('23') }

  context 'quando o usuário existe' do
    it 'responde 200' do
      get '/produtos', id_usuario: usuario.id
      expect(last_response.status).to eq(200)
    end
  end

  context 'quando o usuário não existe' do
    it 'responde 404' do
      get '/produtos', id_usuario: 0
      expect(last_response.status).to eq(404)
    end
  end
end
