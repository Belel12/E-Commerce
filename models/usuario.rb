require 'digest'
class Usuario < ActiveRecord::Base
  validates :nome, presence: { message: 'É OBRIGATÓRIO' }
  validates :email, { presence: { message: 'É OBRIGATÓRIO' },
                      uniqueness: { message: 'JA ESTA CADASTRADO' },
                      format: { with: URI::MailTo::EMAIL_REGEXP, message: 'FORMATO INVÁLIDO' }
  }
  validates :cpf, presence: { message: 'É OBRIGATÓRIO' },
                  format: { with: /\A\d+\z/, message: 'FORMATO INVÁLIDO'},
                  length: { is: 11 , message: 'DEVE CONTER 11 DIGITOS'},
                  uniqueness: { message: 'JÁ EXISTE NO BANCO'}
  validates :senha_hash, { presence: { message: 'É OBRIGATÓRIA'},
                           length: { minimum: 8, message: 'DEVE TER NO MÍNIMO 8 CARACTERES'}
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

