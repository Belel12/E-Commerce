describe Produto, 'TESTES' do
  #TODO: testar quando apaga o produto se a fk em item_venda fica nulo
  let!(:usuario) {
    Usuario.create(
      nome: 'fulano',
      senha_hash: 'senha1234',
      email: 'fulanoDoGrau69@hotmail.com',
      cpf: '01234567890'
    )
  }
  context 'produto valido' do
    let(:produto){
      Produto.new(
        nome: 'Pao de Queijo',
        descricao: nil,
        preco: '10.2',
        estoque: 5,
        usuario: usuario
      )
    }
    it 'deve ser persistido com sucesso' do
      expect(produto.save).to be true
    end

    it 'deve ser apagado apos delete do usuario' do
      usuario.destroy
      expect { produto.reload }.to raise_exception ActiveRecord::RecordNotFound
    end
  end

  context 'produto invalido' do
    let(:produto){
      Produto.new(
        nome: nil,
        descricao: nil,
        preco: nil,
        estoque: nil,
        usuario: nil
      )
    }

    it 'nao deve ser persistido com sucesso' do
      produto.save
      expect(produto.errors.full_messages.count).to be == 6
    end
  end
end