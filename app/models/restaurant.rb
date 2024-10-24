class Restaurant < ApplicationRecord
  belongs_to :owner

  before_validation :generate_code

  validates :brand_name, :corporate_name, :cnpj, :full_address, :phone, :email, presence: true
  validates :corporate_name, :cnpj, :full_address, :code, uniqueness: true

  validate :email_must_be_valid
  validate :cnpj_must_be_numeric, :cnpj_must_have_14_chars, :cnpj_must_be_valid

  private

  def generate_code
    self.code = SecureRandom.alphanumeric(6).upcase
  end

  def email_must_be_valid
    unless email.present? && email.match?(/\A[^@\s]+@[^@\s]+\z/)
      errors.add(:email, 'não é válido')
    end
  end

  def cnpj_must_be_numeric
    unless cnpj.present? && cnpj.chars.all? { |char| ('0'..'9').include? char }
      errors.add(:cnpj, 'deve ser composto apenas por números')
    end
  end

  def cnpj_must_have_14_chars
    unless cnpj.present? && cnpj.length == 14
      errors.add(:cnpj, 'deve ter 14 caracteres')
    end
  end

  def cnpj_must_be_valid
    unless cnpj.present? && CNPJ.valid?(cnpj)
      errors.add(:cnpj, 'não é válido')
    end
  end
end
