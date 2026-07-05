class ProdutoApagadoError < StandardError
  def initialize(msg = '',produtos_apagados)
    super msg
    @produtos_apagados=produtos_apagados
  end
end