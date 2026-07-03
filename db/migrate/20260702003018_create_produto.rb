class CreateProduto < ActiveRecord::Migration[7.1]
  def change
    create_table :produtos do |produto|
      produto.string :nome, null:false
      produto.string :descricao
      produto.decimal :preco, null:false,precision: 8, scale: 2
      produto.integer :estoque, null:false
      produto.references :usuario, null:false, foreign_key:true
    end
  end
end