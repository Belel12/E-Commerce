class Venda < ActiveRecord::Base
  #define enum pro atributo status com array de simbolos
  enum status: {
    pendente: 'pendente',
    paga: 'paga',
    enviada: 'enviada',
    cancelada: 'cancelada',
    entregue: 'entregue',
  }

  validates :status, presence: true, inclusion: { in: statuses.keys }
  validates :data, presence:true
  validates :valor_total, presence:true, numericality: { greater_than_or_equal_to: 0 }
  validates :comprador, presence:true
  validates :vendedor, presence:true

  belongs_to :comprador, class_name: 'Usuario'
  belongs_to :vendedor, class_name: 'Usuario'

  has_many :itens_venda, dependent: :destroy
  has_many :itens_venda, class_name: 'ItemVenda', dependent: :destroy, foreign_key: :venda_id
  has_many :produtos, through: :itens_venda
end

