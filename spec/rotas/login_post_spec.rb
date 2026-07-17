require_relative 'support'

describe 'POST /login', type: :route do
  let!(:usuario) { usuario_valido('3') }

  context 'quando as credenciais são válidas' do
    it 'responde 200' do
      post '/login', email: usuario.email, senha: 'senha-segura'
      expect(last_response.status).to eq(200)
    end
  end

  context 'quando a senha é inválida' do
    it 'responde 422' do
      post '/login', email: usuario.email, senha: 'senha-incorreta'
      expect(last_response.status).to eq(422)
    end
  end

  context 'quando o e-mail não existe' do
    it 'responde 404' do
      post '/login', email: 'ausente@example.com', senha: 'senha-segura'
      expect(last_response.status).to eq(404)
    end
  end
end
