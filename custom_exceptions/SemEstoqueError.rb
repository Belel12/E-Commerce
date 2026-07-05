class SemEstoqueError < StandardError
  def initialize(msg = '', itens_inconsistentes)
    super msg
    @itens_inconsistentes=itens_inconsistentes
  end
end