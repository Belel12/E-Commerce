# frozen_string_literal: true

require_relative 'support'

describe 'GET /itens_venda', type: :route do
  let!(:comprador) { usuario_valido('15') }
  let!(:vendedor) { usuario_valido('16') }
  let!(:venda) do
    Venda.create!(comprador: comprador, vendedor: vendedor, data: Date.today, status: 'pendente', valor_total: 0)
  end

  context 'quando a venda existe' do
    it 'responde 200' do
      get '/itens_venda', id_venda: venda.id, id_usuario: comprador.id
      expect(last_response.status).to eq(200)
    end
  end

  context 'quando a venda não existe' do
    it 'responde 404' do
      get '/itens_venda', id_venda: 0
      expect(last_response.status).to eq(404)
    end
  end
end
