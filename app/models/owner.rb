class Owner < ApplicationRecord
  has_one :restaurant
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :cpf, :name, :surname, presence: true
  validates :cpf, uniqueness: true
  validate :cpf_must_have_11_chars, :cpf_must_be_numeric, :cpf_must_be_valid

  private

  def cpf_must_have_11_chars
    unless cpf.present? && cpf.length == 11
      errors.add(:cpf, 'deve ter 11 caracteres')
    end
  end

  def cpf_must_be_numeric
    unless cpf.present? && cpf.chars.all? { |char| ('0'..'9').include? char }
      errors.add(:cpf, 'deve ser composto apenas por números')
    end
  end

  def cpf_must_be_valid
    unless cpf.present? && CPF.valid?(cpf)
      errors.add(:cpf, 'não é válido')
    end
  end
end
