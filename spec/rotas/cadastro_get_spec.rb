# frozen_string_literal: true

require_relative 'support'

describe 'GET /cadastro', type: :route do
  context 'quando a tela de cadastro é solicitada' do
    it 'responde 200' do
      get '/cadastro'
      expect(last_response.status).to eq(200)
    end
  end
end
