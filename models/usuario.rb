require 'digest'

class Usuario < ActiveRecord::Base
  validates :nome, presence:true
  validates :email, { presence: true,
                      uniqueness: true,
                      format: { with: URI::MailTo::EMAIL_REGEXP }
  }
  validates :cpf, presence: true, format: { with: /\A\d+\z/}
  validates :senha_hash, { presence: true,
                           length: { minimum: 8 }
  }

  has_many :produtos, dependent: :restrict_with_exception, class_name: 'Produto', foreign_key: :usuario_id
  has_many :vendas, dependent: :restrict_with_exception, foreign_key: :vendedor_id
  has_many :compras, class_name: 'Venda', dependent: :restrict_with_exception, foreign_key: :comprador_id
  has_many :produtos_carrinho, dependent: :restrict_with_exception, class_name:'ItemCarrinho', foreign_key: :usuario_id

  before_save :hash_password!

  private
  def hash_password!
    self.senha_hash = Digest::MD5.hexdigest self.senha_hash.to_s
  end
end

