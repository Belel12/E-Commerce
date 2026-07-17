require_relative 'support'

describe 'GET /compras', type: :route do
  let!(:usuario) { usuario_valido('14') }

  context 'quando o usuário é informado' do
    it 'responde 200' do
      get '/compras', id_usuario: usuario.id
      expect(last_response.status).to eq(200)
    end
  end
end
