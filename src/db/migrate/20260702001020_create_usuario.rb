class CreateUsuario < ActiveRecord::Migration[7.1]
  def change
    create_table :usuarios do |usuario|
      usuario.string :nome, null:false
      usuario.string :email, null:false
      usuario.string :senha_hash, null:false
      usuario.string :cpf, null:false
      usuario.string :telefone
    end
  end
end