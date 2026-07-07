require_relative '../custom_exceptions/SemEstoqueError'

class ItemCarrinho < ActiveRecord::Base
  self.table_name= :itens_carrinho

  belongs_to :usuario
  belongs_to :produto

  validates :usuario, presence: true
  validates :produto, presence: true
  validates :produto, uniqueness: { scope: :usuario }
  validates :quantidade, presence: true, numericality: { greater_than: 0 }

  before_save :validar_estoque

  private
  def validar_estoque
    if self.quantidade > self.produto.estoque
      raise SemEstoqueError.new("PRODUTO #{self.produto.nome} NAO TEM ESTOQUE SUFICIENTE",self.produto)
    end
  end
end