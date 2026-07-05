require_relative '../custom_exceptions/SemEstoqueError'
require_relative '../custom_exceptions/ProdutoApagadoError'

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

  has_many :itens_venda, class_name: 'ItemVenda', dependent: :destroy, foreign_key: :venda_id
  has_many :produtos, through: :itens_venda

  before_save :atualizar_estoque, if: -> {self.status == 'paga'}

  def validar_venda
    begin
      verificar_produtos_apagados
      verificar_inconsistencia_estoque
    rescue ProdutoApagadoError
      raise
    rescue SemEstoqueError
      raise
    end
  end
  private
  def atualizar_estoque
    itens_venda.each do |item|
      produto = item.produto
      produto.update! estoque: produto.estoque-item.quantidade
    end
  end

  def verificar_produtos_apagados
    produtos_apagados = Array.new
    itens_venda.each do |item|
      if item.produto.nil? then produtos_apagados << item end
    end
    if produtos_apagados.count > 0
      raise ProdutoApagadoError.new 'Produtos foram apagados',produtos_apagados
    end
  end

  def verificar_inconsistencia_estoque
    itens_inconsistentes = Array.new
    itens_venda.each do |item|
      if item.produto.estoque < item.quantidade
        itens_inconsistentes << item
      end
    end
    if itens_inconsistentes.count > 0
      raise SemEstoqueError.new 'sem produtos suficientes no estoque',itens_inconsistentes
    end
  end
end

