# frozen_string_literal: true

class Produto < ActiveRecord::Base
  validates :nome, presence: true
  validates :preco, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :estoque, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :usuario, presence: true

  belongs_to :usuario

  has_many :itens_vendas, dependent: :nullify, class_name: 'ItemVenda'
  has_many :itens_carrinho, dependent: :destroy, class_name: 'ItemCarrinho'
end
