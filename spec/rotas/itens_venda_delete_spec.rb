# frozen_string_literal: true

require_relative 'support'

describe 'DELETE /itens_venda', type: :route do
  let!(:comprador) { usuario_valido('21') }
  let!(:vendedor) { usuario_valido('22') }
  let!(:produto) { produto_valido(vendedor) }
  let!(:venda) do
    Venda.create!(comprador: comprador, vendedor: vendedor, data: Date.today, status: 'pendente', valor_total: 0)
  end
  let!(:item) { ItemVenda.create!(venda: venda, produto: produto, quantidade: 1, preco_unitario: produto.preco) }

  context 'quando os ids dos itens não são informados' do
    it 'responde 400' do
      delete '/itens_venda'
      expect(last_response.status).to eq(400)
    end
  end

  context 'quando os itens existem' do
    it 'responde 204' do
      delete '/itens_venda', id_itens: [item.id]
      expect(last_response.status).to eq(204)
    end
  end
end
