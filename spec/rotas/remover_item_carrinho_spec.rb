# frozen_string_literal: true

require_relative 'support'

describe 'DELETE /remover_item_carrinho', type: :route do
  let!(:usuario) { usuario_valido('8') }
  let!(:vendedor) { usuario_valido('9') }
  let!(:produto) { produto_valido(vendedor) }
  let!(:item) { ItemCarrinho.create!(usuario: usuario, produto: produto, quantidade: 1) }

  context 'quando o item existe' do
    it 'responde 204' do
      delete '/remover_item_carrinho', id_item: item.id
      expect(last_response.status).to eq(204)
    end
  end

  context 'quando o item não existe' do
    it 'responde 404' do
      delete '/remover_item_carrinho', id_item: 0
      expect(last_response.status).to eq(404)
    end
  end
end
