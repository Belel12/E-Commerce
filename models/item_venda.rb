# frozen_string_literal: true

class ItemVenda < ActiveRecord::Base
  self.table_name = 'itens_venda'

  validates :quantidade, presence: true, numericality: { greater_than: 0 }
  validates :preco_unitario, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :venda, presence: true

  belongs_to :produto
  belongs_to :venda

  before_save :validar_presenca_produto
  before_save :somar_total
  before_destroy :subtrair_total

  private

  def somar_total
    venda.update!(valor_total: venda.valor_total + preco_unitario * quantidade)
  end

  def subtrair_total
    venda.update!(valor_total: venda.valor_total - preco_unitario * quantidade)
  end

  def validar_presenca_produto
    return unless produto.nil?

    errors.add(:produto, message: 'produto deste item não existe')
  end
end
