# frozen_string_literal: true

class CreateVenda < ActiveRecord::Migration[7.1]
  def change
    create_table :vendas do |venda|
      venda.date :data, null: false
      venda.string :status, null: false
      venda.decimal :valor_total, precision: 8, scale: 2, default: 0

      venda.references :comprador, null: false, foreign_key: { to_table: :usuarios }
      venda.references :vendedor, null: false, foreign_key: { to_table: :usuarios }
    end
  end
end
