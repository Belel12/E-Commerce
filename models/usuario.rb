require 'digest'

class Usuario < ActiveRecord::Base
  validates :nome, presence:true
  validates :email, { presence: true,
                      uniqueness: true,
                      format: { with: URI::MailTo::EMAIL_REGEXP }
  }
  validates :cpf, presence: true
  validates :senha_hash, { presence: true,
                           length: { minimum: 8 },
                           message: 'senha deve ter no minimo 8 caracteres' }

  has_many :produtos, dependent: :destroy
  has_many :vendas, dependent: :nullify

  before_save :hash_password!

  private
  def hash_password!
    self.senha_hash = Digest::MD5.hexdigest self.senha_hash.to_s
  end
end

