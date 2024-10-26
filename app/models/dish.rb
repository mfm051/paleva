class Dish < ApplicationRecord
  has_one_attached :illustration

  belongs_to :restaurant

  validates :name, :description, presence: true
  validates :name, uniqueness: true
end
