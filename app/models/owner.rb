class Owner < ApplicationRecord
  has_one :restaurant, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :cpf, :name, :surname, presence: true
  validates :cpf, uniqueness: true
  validate :cpf_must_have_11_chars, :cpf_must_be_numeric, :cpf_must_be_valid

  private

  def cpf_must_have_11_chars
    return unless cpf.present?

    unless cpf.length == 11
      errors.add(:cpf, 'deve ter 11 caracteres')
    end
  end

  def cpf_must_be_numeric
    return unless cpf.present?

    unless cpf.chars.all? { |char| ('0'..'9').include? char }
      errors.add(:cpf, 'deve ser composto apenas por números')
    end
  end

  def cpf_must_be_valid
    return unless cpf.present?

    unless CPF.valid?(cpf)
      errors.add(:cpf, 'não é válido')
    end
  end
end
