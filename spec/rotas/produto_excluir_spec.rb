require_relative 'support'

describe 'POST /produtos/:id/excluir', type: :route do
  let!(:usuario) { usuario_valido('26') }
  let!(:produto) { produto_valido(usuario) }

  context 'quando o usuário não existe' do
    it 'responde 404' do
      post "/produtos/#{produto.id}/excluir", id_usuario: 0
      expect(last_response.status).to eq(404)
    end
  end

  context 'quando o produto não pertence ao usuário' do
    it 'responde 404' do
      post '/produtos/0/excluir', id_usuario: usuario.id
      expect(last_response.status).to eq(404)
    end
  end

  context 'quando o produto pertence ao usuário' do
    it 'responde 302' do
      post "/produtos/#{produto.id}/excluir", id_usuario: usuario.id
      expect(last_response.status).to eq(302)
    end
  end
end
