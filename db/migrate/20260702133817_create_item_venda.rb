class CreateItemVenda < ActiveRecord::Migration[7.1]
  def change
    create_table :itens_venda do |item|
      item.references :vendas, null:false, foreign_key:true
      item.references :produtos, foreign_key:true
      item.integer :quantidade, null:false
      item.decimal :preco_unitario, null:false, precision: 8, scale: 2
    end
  end
end