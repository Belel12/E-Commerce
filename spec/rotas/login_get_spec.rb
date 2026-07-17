require_relative 'support'

describe 'GET /login', type: :route do
  context 'quando a tela de login é solicitada' do
    it 'responde 200' do
      get '/login'
      expect(last_response.status).to eq(200)
    end
  end
end
