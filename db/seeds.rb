# db/seeds.rb
puts 'Limpando dados antigos (ordem por causa das FKs)...'
ItensVenda.delete_all
Venda.delete_all
Produto.delete_all
Usuario.delete_all

puts 'Criando usuários...'

usuarios = [
  { nome: 'Ana Silva',    email: 'ana.silva@teste.com',    cpf: '11111111111', senha_hash: 'senha1234', telefone: '62999990001' },
  { nome: 'Bruno Costa',  email: 'bruno.costa@teste.com',  cpf: '22222222222', senha_hash: 'senha1234', telefone: '62999990002' },
  { nome: 'Carla Souza',  email: 'carla.souza@teste.com',  cpf: '33333333333', senha_hash: 'senha1234', telefone: '62999990003' },
  { nome: 'Diego Lima',   email: 'diego.lima@teste.com',   cpf: '44444444444', senha_hash: 'senha1234', telefone: '62999990004' },
  { nome: 'Elisa Rocha',  email: 'elisa.rocha@teste.com',  cpf: '55555555555', senha_hash: 'senha1234', telefone: '62999990005' }
].map { |attrs| Usuario.create!(attrs) }

puts "#{usuarios.count} usuários criados."

puts 'Criando produtos...'

nomes_produtos = [
  'Caneta Esferográfica', 'Caderno Universitário', 'Mochila Escolar',
  'Fone de Ouvido Bluetooth', 'Teclado Mecânico', 'Mouse sem Fio',
  'Monitor 24 polegadas', 'Cadeira Gamer', 'Garrafa Térmica', 'Lâmpada Inteligente'
]

produtos = nomes_produtos.map do |nome|
  Produto.create!(
    nome: nome,
    descricao: "Descrição do produto #{nome}",
    preco: rand(10.0..500.0).round(2),
    estoque: rand(1..100),
    usuario: usuarios.sample
  )
end

puts "#{produtos.count} produtos criados."

puts 'Criando vendas com itens...'

status_possiveis = %i[pendente paga enviada entregue cancelada]

10.times do
  comprador, vendedor = usuarios.sample(2)

  venda = Venda.create!(
    data: rand(30..365).days.ago.to_date,
    status: status_possiveis.sample,
    valor_total: 0, # recalculado logo abaixo
    comprador: comprador,
    vendedor: vendedor
  )

  itens = produtos.sample(rand(1..3))
  total = 0

  itens.each do |produto|
    quantidade = rand(1..5)
    preco_unitario = produto.preco

    ItensVenda.create!(
      venda: venda,
      produto: produto,
      quantidade: quantidade,
      preco_unitario: preco_unitario
    )

    total += quantidade * preco_unitario
  end

  venda.update!(valor_total: total)
end

puts "#{Venda.count} vendas criadas com #{ItensVenda.count} itens no total."
puts 'Seed finalizado!'