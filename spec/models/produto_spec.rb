# frozen_string_literal: true

describe Produto, 'TESTES' do
  let!(:usuario) do
    Usuario.create(
      nome: 'fulano',
      senha_hash: 'senha1234',
      email: 'fulanoDoGrau69@hotmail.com',
      cpf: '01234567890'
    )
  end
  context 'produto valido' do
    let!(:produto) do
      Produto.new(
        nome: 'Pao de Queijo',
        descricao: nil,
        preco: '10.2',
        estoque: 5,
        usuario: usuario
      )
    end
    it 'deve ser persistido com sucesso' do
      expect(produto.save).to be true
    end
  end

  context 'produto invalido' do
    let(:produto)  do
      Produto.new(
        nome: nil,
        descricao: nil,
        preco: nil,
        estoque: nil,
        usuario: nil
      )
    end

    it 'nao deve ser persistido com sucesso' do
      produto.save
      expect(produto.errors.full_messages.count).to be == 6
    end
  end
end
