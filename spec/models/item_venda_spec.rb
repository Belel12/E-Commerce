describe ItemVenda, 'TESTES' do
  let!(:vendedor) {
    Usuario.create(
      nome: 'fulano',
      senha_hash: 'senha1234',
      email: 'fulanoDoGrau69@hotmail.com',
      cpf: '01234567890'
    )
  }
  let!(:comprador) {
    Usuario.create(
      nome: 'fulano2',
      senha_hash: 'senha1234',
      email: 'fulanoDoGrau67@hotmail.com',
      cpf: '01234567899'
    )
  }
  let!(:produto){
    Produto.create(
      nome: 'Pao de Queijo',
      descricao: 'pao de queijo uai',
      preco: '10.2',
      estoque: 10,
      usuario: vendedor
    )
  }
  let!(:venda) {
    Venda.create(
      data: Date.today,
      status: :pendente,
      comprador: comprador,
      vendedor: vendedor,
      valor_total: 0
    )
  }

  context 'item da venda valido' do
    let(:item) {
      ItemVenda.new(
        venda: venda,
        produto: produto,
        quantidade: 5,
        preco_unitario: produto.preco
      )
    }

    it 'deve poder ser persistido com sucesso' do
      expect(item).to be_valid
    end

    it 'deve somar ao valor total da venda ao ser adicionado' do
      expect {item.save}.to change{venda.valor_total}.by(item.preco_unitario*item.quantidade)
    end

    it 'deve subtrair ao valor total da venda ao ser removido' do
      venda.update valor_total: venda.valor_total + item.preco_unitario*item.quantidade
      expect {item.destroy}.to change{venda.valor_total}.by(-item.preco_unitario*item.quantidade)
    end
  end

  context 'ao ter produto referenciado apagado' do
    let!(:item) {
      ItemVenda.create(
        venda: venda,
        produto: produto,
        quantidade: 5,
        preco_unitario: produto.preco
      )
    }

    it 'deve ficar com a referencia nula' do
      expect{produto.destroy}.to change{item.reload.produto}.from(produto).to(nil)
    end
  end

  context 'ao ter venda referenciada apagada' do
    let!(:item) {
      ItemVenda.create(
        venda: venda,
        produto: produto,
        quantidade: 5,
        preco_unitario: produto.preco
      )
    }
    it 'deve ser obliterado com sucesso' do
      venda.destroy
      expect { item.reload }.to raise_exception ActiveRecord::RecordNotFound
    end

  end
end