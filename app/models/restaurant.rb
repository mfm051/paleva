class Restaurant < ApplicationRecord
  belongs_to :owner
  has_many :dishes, dependent: :destroy
  has_many :drinks, dependent: :destroy
  has_many :schedules, dependent: :destroy
  accepts_nested_attributes_for :schedules

  before_validation :generate_code

  validates :brand_name, :corporate_name, :cnpj, :full_address, :phone, :email, presence: true
  validates :corporate_name, :cnpj, :full_address, :code, uniqueness: true

  validates :phone, length: { in: 10..11 }
  validates :cnpj, length: { is: 14 }
  validates :phone, :cnpj, format: { with: /\A\d+\z/, message: "deve ser composto apenas por números" }
  validates :email, format: { with: /\A[^@\s]+@[^@\s]+\z/ }

  validate :cnpj_must_be_valid

  private

  def generate_code
    self.code = SecureRandom.alphanumeric(6).upcase
  end

  def cnpj_must_be_valid
    return unless cnpj.present?

    unless CNPJ.valid?(cnpj)
      errors.add(:cnpj, 'não é válido')
    end
  end
end
