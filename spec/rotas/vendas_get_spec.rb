# frozen_string_literal: true

require_relative 'support'

describe 'GET /vendas', type: :route do
  let!(:usuario) { usuario_valido('27') }

  context 'quando o usuário existe' do
    it 'responde 200' do
      get '/vendas', id_usuario: usuario.id
      expect(last_response.status).to eq(200)
    end
  end
end
