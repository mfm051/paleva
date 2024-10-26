class Drink < ApplicationRecord
  has_one_attached :illustration

  belongs_to :restaurant

  validates :name, :description, presence: true
  validates :alcoholic, inclusion: [true, false]
  validates :name, uniqueness: true
end
