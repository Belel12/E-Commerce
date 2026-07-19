# frozen_string_literal: true

require_relative 'support'

describe 'GET /', type: :route do
  let!(:vendedor) { usuario_valido('2') }
  let!(:produto) { produto_valido(vendedor, nome: 'Cafe') }

  context 'quando a página inicial é solicitada' do
    it 'responde 200' do
      get '/', busca: 'Cafe'
      expect(last_response.status).to eq(200)
    end
  end
end
