class Dish < ApplicationRecord
  enum :status, active: 0, inactive: 5

  has_one_attached :illustration
  has_many :portions, as: :portionable

  belongs_to :restaurant

  validates :name, :description, presence: true
  validates :name, uniqueness: true
end
