class ItensVenda < ActiveRecord::Base
  self.table_name = "itens_vendas"

  validates :quantidade, presence: true, numericality: { greater_than: 0 }
  validates :preco_unitario, presence: true, numericality: { greater_than_or_equal_to: 0 }

  belongs_to :produto
  belongs_to :venda
end

