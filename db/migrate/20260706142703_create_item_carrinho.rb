class CreateItemCarrinho < ActiveRecord::Migration[7.1]
  def change
    create_table :itens_carrinho do |carrinho|
      carrinho.references :usuario, null:false, foreign_key: { to_table: :usuarios }
      carrinho.references :produto, null:false, foreign_key: { to_table: :produtos }
      carrinho.integer :quantidade, null:false
      carrinho.index [:usuario_id, :produto_id], unique: true
    end
  end
end