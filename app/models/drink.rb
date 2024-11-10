class Drink < ApplicationRecord
  enum :status, active: 0, inactive: 5

  belongs_to :restaurant

  has_one_attached :illustration
  has_many :portions, as: :portionable
  has_many :menu_items, as: :itemable

  validates :name, :description, presence: true
  validates :alcoholic, inclusion: [true, false]
  validates :name, uniqueness: true
end
