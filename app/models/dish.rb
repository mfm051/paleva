class Dish < ApplicationRecord
  belongs_to :restaurant

  validates :name, :description, presence: true
  validates :name, uniqueness: true
end
