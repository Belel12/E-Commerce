# frozen_string_literal: true

describe Venda, 'TESTES' do
  let!(:vendedor) do
    Usuario.create(
      nome: 'fulano',
      senha_hash: 'senha1234',
      email: 'fulanoDoGrau69@hotmail.com',
      cpf: '01234567890'
    )
  end
  let!(:comprador) do
    Usuario.create(
      nome: 'fulano2',
      senha_hash: 'senha1234',
      email: 'fulanoDoGrau67@hotmail.com',
      cpf: '01234567899'
    )
  end
  let!(:produto) do
    Produto.create(
      nome: 'Pao de Queijo',
      descricao: 'pao de queijo uai',
      preco: '10.2',
      estoque: 10,
      usuario: vendedor
    )
  end

  context 'venda valida com todos os atributos' do
    let(:venda) do
      Venda.new(
        data: Date.today,
        status: :pendente,
        comprador: comprador,
        vendedor: vendedor,
        valor_total: 0
      )
    end

    it 'deve poder ser persistida' do
      expect(venda).to be_valid
    end

    it 'deve atualizar o estoque dos produtos ao ser finalizada/paga' do
      item = ItemVenda.create(
        venda: venda,
        produto: produto,
        preco_unitario: produto.preco,
        quantidade: 2
      )

      expect { venda.update(status: 'paga') }.to change { produto.reload.estoque }.by(-item.quantidade)
    end

    it 'deve gerar SemEstoqueError ao tentar reservar uma
        quantidade de um produto que seja maior que a disponivel no estoque' do
      ItemVenda.create(
        venda: venda,
        produto: produto,
        preco_unitario: produto.preco,
        quantidade: produto.estoque + 1
      )

      expect { venda.validar_venda }.to raise_error(SemEstoqueError)
    end

    it 'deve gerar ProdutoApagadoError ao tentar reservar um produto que tenha sido excluido' do
      ItemVenda.create(
        venda: venda,
        produto: produto,
        preco_unitario: produto.preco,
        quantidade: produto.estoque
      )

      produto.destroy!
      expect { venda.validar_venda }.to raise_error(ProdutoApagadoError)
    end
  end

  context 'venda com atributos faltando ou incorretos' do
    let(:venda) do
      Venda.new(
        vendedor: nil,
        comprador: nil,
        data: nil,
        valor_total: nil,
        status: nil
      )
    end

    it 'nao deve ser valida' do
      expect(venda).to_not be_valid
    end

    it 'no pior caso deve gerar 7 erros de verificacao' do
      venda.save
      puts venda.errors.full_messages.inspect
      expect(venda.errors.full_messages.count).to eq 7
    end
  end
end
