# frozen_string_literal: true

class CreateItemVenda < ActiveRecord::Migration[7.1]
  def change
    create_table :itens_venda do |item|
      item.references :venda, null: false, foreign_key: true
      item.references :produto, foreign_key: true
      item.integer :quantidade, null: false
      item.decimal :preco_unitario, null: false, precision: 8, scale: 2
    end
  end
end
