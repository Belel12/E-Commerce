require 'digest'

class Usuario < ActiveRecord::Base
  validates :nome, presence: { message: 'NOME DE USUÁRIO É OBRIGATÓRIO' }
  validates :email, { presence: { message: 'EMAIL É OBRIGATÓRIO' },
                      uniqueness: { message: 'EMAIL JA ESTA CADASTRADO' },
                      format: { with: URI::MailTo::EMAIL_REGEXP, message: 'FORMATO DE EMAIL INVÁLIDO' }
  }
  validates :cpf, presence: { message: 'CPF É OBRIGATÓRIO' },
                  format: { with: /\A\d+\z/, message: 'FORMATO DE CPF INVÁLIDO'}
  validates :senha_hash, { presence: { message: 'SENHA É OBRIGATÓRIA'},
                           length: { minimum: 8, message: 'SENHA DEVE TER NO MÍNIMO 8 CARACTERES'}
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

