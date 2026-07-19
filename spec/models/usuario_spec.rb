# frozen_string_literal: true

describe Usuario, 'TESTES' do
  context 'usuario com atributos validos' do
    before :each do
      @usuario = Usuario.new(
        nome: 'fulano',
        senha_hash: 'senha1234',
        email: 'fulanoDoGrau69@hotmail.com',
        cpf: '01234567890'
      )
      @senha_original = @usuario.senha_hash
    end

    it 'deve ser persistido com sucesso' do
      expect(@usuario.save).to be true
    end

    it 'deve ter tido a senha hasheada antes de ser salvo' do
      @usuario.save
      expect(@usuario.senha_hash).to_not eq(@senha_original)
    end
  end

  context 'usuario com qualquer atributo nulo' do
    let(:usuario_defeituoso) do
      Usuario.new(
        nome: '',
        email: '',
        cpf: '',
        senha_hash: ''
      )
    end

    it 'nao deve ser persistido com sucesso' do
      expect(usuario_defeituoso.save).to be false
    end
  end

  context 'usuario tenta cadastrar um email que ja existe no banco' do
    let!(:usuario_valido1) do
      Usuario.create(
        nome: 'fulano1',
        email: 'emailunico@gmail.com',
        cpf: '01234567890',
        senha_hash: 'senha1234'
      )
    end
    let(:usuario_valido2) do
      Usuario.new(
        nome: 'fulano2',
        email: 'emailunico@gmail.com',
        cpf: '01234567890',
        senha_hash: 'senha1234'
      )
    end

    it 'nao deve ser cadastrado' do
      expect(usuario_valido2).to_not be_valid
    end
  end

  context 'usuario com letras no cpf' do
    let(:usuario_com_letras) do
      Usuario.new(
        nome: 'fulano',
        email: 'email@gmail.com',
        cpf: 'c1234b6789a',
        senha_hash: 'senha1234'
      )
    end

    it 'nao deve ser persistido com sucesso' do
      expect(usuario_com_letras).to_not be_valid
    end
  end

  context 'usuario com cpf diferente de 11 caracteres' do
    let(:usuario)  do
      Usuario.new(
        nome: 'usuario',
        senha_hash: 'senha1234',
        cpf: '012345678901',
        email: 'teste@gmail.com'
      )
    end

    it 'nao deve poder ser salvo' do
      expect(usuario.save).to be false
    end
  end
end
