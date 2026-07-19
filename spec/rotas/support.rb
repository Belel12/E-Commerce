# frozen_string_literal: true

module RotasSupport
  def app
    ECommerceApp
  end

  def usuario_valido(sufixo = '1')
    Usuario.create!(
      nome: "Usuario #{sufixo}",
      email: "usuario#{sufixo}@example.com",
      cpf: sufixo.to_s.rjust(11, '0'),
      senha_hash: 'senha-segura'
    )
  end

  def produto_valido(usuario, nome: 'Produto', estoque: 10)
    Produto.create!(nome: nome, preco: 10, estoque: estoque, usuario: usuario)
  end
end

RSpec.configure do |config|
  config.include RotasSupport, type: :route
end
