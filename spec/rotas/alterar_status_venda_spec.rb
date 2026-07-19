# frozen_string_literal: true

require_relative 'support'
require 'json'

describe 'PUT /alterar_status_venda', type: :route do
  let!(:comprador) { usuario_valido('18') }
  let!(:vendedor) { usuario_valido('19') }
  let!(:outro_usuario) { usuario_valido('20') }
  let!(:venda) do
    Venda.create!(comprador: comprador, vendedor: vendedor, data: Date.today, status: 'pendente', valor_total: 0)
  end

  def alterar_status(dados)
    put '/alterar_status_venda', dados.to_json, 'CONTENT_TYPE' => 'application/json'
  end

  context 'quando faltam parâmetros' do
    it 'responde 400' do
      alterar_status(id_venda: venda.id)
      expect(last_response.status).to eq(400)
    end
  end

  context 'quando o usuário não existe' do
    it 'responde 404' do
      alterar_status(id_venda: venda.id, id_usuario: 0, novo_status: 'paga')
      expect(last_response.status).to eq(404)
    end
  end

  context 'quando a venda não existe' do
    it 'responde 404' do
      alterar_status(id_venda: 0, id_usuario: comprador.id, novo_status: 'paga')
      expect(last_response.status).to eq(404)
    end
  end

  context 'quando o usuário não participa da venda' do
    it 'responde 400' do
      alterar_status(id_venda: venda.id, id_usuario: outro_usuario.id, novo_status: 'paga')
      expect(last_response.status).to eq(400)
    end
  end

  context 'quando o status não é permitido ao usuário' do
    it 'responde 403' do
      alterar_status(id_venda: venda.id, id_usuario: comprador.id, novo_status: 'enviada')
      expect(last_response.status).to eq(403)
    end
  end

  context 'quando o status é permitido ao comprador' do
    it 'responde 200' do
      alterar_status(id_venda: venda.id, id_usuario: comprador.id, novo_status: 'paga')
      expect(last_response.status).to eq(200)
    end
  end

  context 'quando não há estoque suficiente para pagar a venda' do
    let!(:produto) { produto_valido(vendedor, estoque: 1) }
    let!(:item) { ItemVenda.create!(venda: venda, produto: produto, quantidade: 2, preco_unitario: produto.preco) }

    it 'responde 422' do
      alterar_status(id_venda: venda.id, id_usuario: comprador.id, novo_status: 'paga')
      expect(last_response.status).to eq(422)
    end
  end

  context 'quando um produto da venda foi apagado' do
    let!(:produto) { produto_valido(vendedor) }
    let!(:item) { ItemVenda.create!(venda: venda, produto: produto, quantidade: 1, preco_unitario: produto.preco) }

    it 'responde 422' do
      produto.destroy!
      alterar_status(id_venda: venda.id, id_usuario: comprador.id, novo_status: 'paga')
      expect(last_response.status).to eq(422)
    end
  end
end
