class ItemVenda < ActiveRecord::Base
  self.table_name = 'itens_venda'

  validates :quantidade, presence: true, numericality: { greater_than: 0 }
  validates :preco_unitario, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :venda, presence: true

  belongs_to :produto
  belongs_to :venda

  before_save :somar_total
  before_destroy :substrair_total

  private
  def somar_total
    self.venda.valor_total += self.preco_unitario * self.quantidade
  end

  def subtrair_total
    self.venda.valor_total -= self.preco_unitario * self.quantidade
  end
end

