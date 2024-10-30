class Owner < ApplicationRecord
  has_one :restaurant, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :cpf, :name, :surname, presence: true
  validates :cpf, length: { is: 11 }
  validates :cpf, format: { with: /\A\d+\z/, message: "deve ser composto apenas por números" }
  validates :cpf, uniqueness: true

  validate :cpf_must_be_valid

  private

  def cpf_must_be_valid
    return unless cpf.present?

    unless CPF.valid?(cpf)
      errors.add(:cpf, 'não é válido')
    end
  end
end
