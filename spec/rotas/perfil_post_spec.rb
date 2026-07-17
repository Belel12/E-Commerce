require_relative 'support'

describe 'POST /perfil', type: :route do
  let!(:usuario) { usuario_valido('13') }
  let(:dados_conta) { { id_usuario: usuario.id, tipo_alteracao: 'dados_conta', nome: 'Novo nome', cpf: usuario.cpf, telefone: '123' } }

  context 'quando o tipo de alteração não foi informado' do
    it 'responde 400' do
      post '/perfil', dados_conta.except(:tipo_alteracao)
      expect(last_response.status).to eq(400)
    end
  end

  context 'quando o usuário não existe' do
    it 'responde 404' do
      post '/perfil', dados_conta.merge(id_usuario: 0)
      expect(last_response.status).to eq(404)
    end
  end

  context 'quando os dados da conta são válidos' do
    it 'responde 200' do
      post '/perfil', dados_conta
      expect(last_response.status).to eq(200)
    end
  end

  context 'quando os dados da conta são inválidos' do
    it 'responde 422' do
      post '/perfil', dados_conta.merge(cpf: 'invalido')
      expect(last_response.status).to eq(422)
    end
  end

  context 'quando a alteração de senha é válida' do
    it 'responde 200' do
      post '/perfil', id_usuario: usuario.id, tipo_alteracao: 'alterar_senha', senha_atual: 'senha-segura', nova_senha: 'nova-senha', confirmar_nova_senha: 'nova-senha'
      expect(last_response.status).to eq(200)
    end
  end

  context 'quando a senha atual é inválida' do
    it 'responde 422' do
      post '/perfil', id_usuario: usuario.id, tipo_alteracao: 'alterar_senha', senha_atual: 'errada', nova_senha: 'nova-senha', confirmar_nova_senha: 'nova-senha'
      expect(last_response.status).to eq(422)
    end
  end

  context 'quando as novas senhas são diferentes' do
    it 'responde 422' do
      post '/perfil', id_usuario: usuario.id, tipo_alteracao: 'alterar_senha', senha_atual: 'senha-segura', nova_senha: 'nova-senha', confirmar_nova_senha: 'outra-senha'
      expect(last_response.status).to eq(422)
    end
  end
end
