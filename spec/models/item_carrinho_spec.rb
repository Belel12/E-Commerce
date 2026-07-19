# frozen_string_literal: true

describe ItemCarrinho, 'TESTES' do
  let!(:usuario) do
    Usuario.create(
      nome: 'jose',
      email: 'josefino@bbmail.com',
      cpf: '01234567890',
      senha_hash: '12345678',
      telefone: '123456'
    )
  end

  let!(:produto) do
    Produto.create(
      nome: 'coca',
      descricao: '',
      preco: '10',
      estoque: 12,
      usuario: usuario
    )
  end

  context 'quando criado com dados validos' do
    let!(:item) do
      ItemCarrinho.create(
        usuario: usuario,
        produto: produto,
        quantidade: 3
      )
    end

    it 'deve poder ser persistido com sucesso no banco' do
      expect(item.valid?).to eq(true)
    end

    it 'deve ser apagado do banco quando o vendedor apagar o produto do item' do
      expect { produto.destroy }.to change { ItemCarrinho.count }.by(-1)
    end
  end

  context 'quando criado com dados faltando' do
    let!(:item) do
      ItemCarrinho.new(
        usuario: nil,
        produto: nil,
        quantidade: nil
      )
    end

    it 'nao deve ser valido' do
      expect(item.valid?).to eq(false)
    end
  end

  context 'quando estoque do produto for menor que a quantidade requisitada' do
    let!(:item) do
      ItemCarrinho.new(
        usuario: usuario,
        produto: produto,
        quantidade: 13
      )
    end

    it 'deve gerar erro ao tentar salvar' do
      expect { item.save }.to change { item.errors.full_messages.count }.by(1)
    end
  end

  context 'quando ja existe um item associado a um usuario e um produto' do
    let!(:item) do
      ItemCarrinho.create(
        usuario: usuario,
        produto: produto,
        quantidade: 3
      )
    end
    it 'nao deve permitir associar o mesmo produto ao mesmo usuario novamente' do
      novo_item = ItemCarrinho.new(
        usuario: usuario,
        produto: produto,
        quantidade: 5
      )
      expect(novo_item.valid?).to eq false
    end
  end
end
