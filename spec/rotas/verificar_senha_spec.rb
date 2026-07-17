require_relative 'support'
require 'json'

describe 'GET /verificar_senha', type: :route do
  let!(:usuario) { usuario_valido('17') }

  context 'quando faltam parâmetros' do
    it 'responde 400' do
      get '/verificar_senha', id_usuario: usuario.id
      expect(last_response.status).to eq(400)
    end
  end

  context 'quando o usuário não existe' do
    it 'responde 404' do
      get '/verificar_senha', id_usuario: 0, senha: 'senha-segura'
      expect(last_response.status).to eq(404)
    end
  end

  context 'quando os parâmetros são válidos' do
    it 'responde 200' do
      get '/verificar_senha', id_usuario: usuario.id, senha: 'senha-segura'
      expect(last_response.status).to eq(200)
    end
  end

  context 'quando a senha não confere' do
    it 'responde 200 com a verificação negativa' do
      get '/verificar_senha', id_usuario: usuario.id, senha: 'senha-incorreta'
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)).to eq('verificacao' => false)
    end
  end
end
