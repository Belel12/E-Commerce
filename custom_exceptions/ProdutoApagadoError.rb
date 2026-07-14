class ProdutoApagadoError < StandardError

  attr_reader :itens_produtos_apagados
  def initialize(msg = '', itens_produtos_apagados)
    super msg
    @itens_produtos_apagados=itens_produtos_apagados
  end
end