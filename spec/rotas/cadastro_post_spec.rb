require_relative 'support'

describe 'POST /cadastro', type: :route do
  let(:atributos_validos) do
    { nome: 'Novo usuario', email: 'novo@example.com', cpf: '12345678901', senha: 'senha-segura', confirmar_senha: 'senha-segura' }
  end

  context 'quando os dados são válidos' do
    it 'responde 201' do
      post '/cadastro', atributos_validos
      expect(last_response.status).to eq(201)
    end
  end

  context 'quando as senhas são diferentes' do
    it 'responde 422' do
      post '/cadastro', atributos_validos.merge(confirmar_senha: 'outra-senha')
      expect(last_response.status).to eq(422)
    end
  end

  context 'quando os dados não passam nas validações' do
    it 'responde 422' do
      post '/cadastro', atributos_validos.merge(email: 'invalido')
      expect(last_response.status).to eq(422)
    end
  end
end
