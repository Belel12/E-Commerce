describe Usuario, 'TESTES' do
  context 'usuario valido' do
    before :each do
      @usuario = Usuario.new(
        nome: 'fulano',
        senha_hash: 'senha1234',
        email: 'fulanoDoGrau69@hotmail.com',
        cpf: '01234567890',
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
    let(:usuario_defeituoso) {
      Usuario.new(
        nome: '',
        email: '',
        cpf: '',
        senha_hash: '',
      )
    }

    it 'nao deve ser persistido com sucesso' do
      usuario_defeituoso.save
      #devem haver 7 erros pois, alem dos 4 nulos,
      # tem 3 verificacoes de formato de:
      # -cpf
      # -email
      # -senha(tamanho)
      # acabam falhando tambem
      expect(usuario_defeituoso.errors.full_messages.count).to be == 7
    end
  end

  context 'usuario tenta cadastrar um email que ja existe' do
    let!(:usuario_valido1) {
      Usuario.create(
        nome: 'fulano1',
        email: 'emailunico@gmail.com',
        cpf: '01234567890',
        senha_hash: 'senha1234',
      )
    }
    let(:usuario_valido2) {
      Usuario.new(
        nome: 'fulano2',
        email: 'emailunico@gmail.com',
        cpf: '01234567890',
        senha_hash: 'senha1234',
      )
    }

    it 'nao deve ser persistido com sucesso' do
      expect(usuario_valido2).to_not be_valid
    end
  end

  context 'usuario com cpf com letras' do
    let(:usuario_com_letras) {
      Usuario.new(
        nome: 'fulano',
        email: 'email@gmail.com',
        cpf: '01234567890abc',
        senha_hash: 'senha1234',
      )
    }

    it 'nao deve ser persistido com sucesso' do
      expect(usuario_com_letras).to_not be_valid
    end
  end
end