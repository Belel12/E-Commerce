class SemEstoqueError < StandardError

  attr_reader :itens_inconsistentes
  def initialize(msg = '', itens_inconsistentes)
    super msg
    @itens_inconsistentes=itens_inconsistentes
  end
end