class Produto < ActiveRecord::Base
  validates :nome, presence: true
  validates :preco, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :estoque, presence:true, numericality: { greater_than_or_equal_to: 0 }

  belongs_to :usuario

  has_many :itens_vendas, dependent: :nullify
end

