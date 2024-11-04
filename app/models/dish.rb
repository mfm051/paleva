class Dish < ApplicationRecord
  enum :status, active: 0, inactive: 5

  has_one_attached :illustration

  belongs_to :restaurant

  validates :name, :description, presence: true
  validates :name, uniqueness: true
end
