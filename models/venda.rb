# frozen_string_literal: true

require_relative '../custom_exceptions/SemEstoqueError'
require_relative '../custom_exceptions/ProdutoApagadoError'

class Venda < ActiveRecord::Base
  enum status: {
    pendente: 'pendente',
    paga: 'paga',
    enviada: 'enviada',
    entregue: 'entregue',
    cancelada: 'cancelada'
  }

  validates :status, presence: true, inclusion: { in: statuses.keys }
  validates :data, presence: true
  validates :valor_total, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :comprador, presence: true
  validates :vendedor, presence: true

  belongs_to :comprador, class_name: 'Usuario'
  belongs_to :vendedor, class_name: 'Usuario'

  has_many :itens_venda, class_name: 'ItemVenda', dependent: :destroy, foreign_key: :venda_id
  has_many :produtos, through: :itens_venda

  before_save :validar_venda
  before_save :atualizar_estoque

  def validar_venda
    verificar_produtos_apagados
    verificar_inconsistencia_estoque
  end

  private

  def atualizar_estoque
    if status_was == 'pendente' && status == 'paga'
      itens_venda.each do |item|
        produto = item.produto
        produto.update! estoque: produto.estoque - item.quantidade
      end
    elsif status_was == 'paga' && status == 'cancelada'
      itens_venda.each do |item|
        produto = item.produto
        produto&.update! estoque: item.quantidade + produto&.estoque
      end
    end
  end

  def verificar_produtos_apagados
    produtos_apagados = itens_venda.where(produto: nil)
    return unless produtos_apagados.count.positive?

    raise ProdutoApagadoError.new 'Produtos foram apagados', produtos_apagados
  end

  def verificar_inconsistencia_estoque
    itens_inconsistentes = itens_venda.joins(:produto)
                                      .where.not(produto: nil)
                                      .where('itens_venda.quantidade > produtos.estoque')
    return unless itens_inconsistentes.count.positive?

    raise SemEstoqueError.new 'sem produtos suficientes no estoque', itens_inconsistentes
  end
end
