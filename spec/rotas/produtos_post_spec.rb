# frozen_string_literal: true

require_relative 'support'

describe 'POST /produtos', type: :route do
  let!(:usuario) { usuario_valido('24') }
  let(:parametros) { { id_usuario: usuario.id, nome: 'Produto novo', preco: 10, estoque: 1 } }

  context 'quando faltam parâmetros' do
    it 'responde 400' do
      post '/produtos', parametros.except(:nome)
      expect(last_response.status).to eq(400)
    end
  end

  context 'quando o usuário não existe' do
    it 'responde 404' do
      post '/produtos', parametros.merge(id_usuario: 0)
      expect(last_response.status).to eq(404)
    end
  end

  context 'quando o produto é válido' do
    it 'responde 302' do
      post '/produtos', parametros
      expect(last_response.status).to eq(302)
    end
  end

  context 'quando o produto é inválido' do
    it 'responde 422' do
      post '/produtos', parametros.merge(preco: -1)
      expect(last_response.status).to eq(422)
    end
  end
end
