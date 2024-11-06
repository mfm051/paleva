class Drink < ApplicationRecord
  enum :status, active: 0, inactive: 5

  has_one_attached :illustration
  has_many :portions, as: :portionable

  belongs_to :restaurant

  validates :name, :description, presence: true
  validates :alcoholic, inclusion: [true, false]
  validates :name, uniqueness: true
end
