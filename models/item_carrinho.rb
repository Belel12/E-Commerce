# frozen_string_literal: true

require_relative '../custom_exceptions/SemEstoqueError'

class ItemCarrinho < ActiveRecord::Base
  self.table_name = :itens_carrinho

  belongs_to :usuario
  belongs_to :produto

  validates :usuario, presence: true
  validates :produto, presence: true
  validates :produto, uniqueness: { scope: :usuario }
  validates :quantidade, presence: true, numericality: { greater_than: 0 }

  before_validation :validar_estoque, if: -> { !produto.nil? }

  private

  def validar_estoque
    return unless quantidade > produto.estoque

    errors.add(:quantidade, message: "PRODUTO #{produto.nome} NAO TEM ESTOQUE SUFICIENTE")
  end
end
