class Drink < ApplicationRecord
  belongs_to :restaurant

  validates :name, :description, presence: true
  validates :alcoholic, inclusion: [true, false]
  validates :name, uniqueness: true
end
