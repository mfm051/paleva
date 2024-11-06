class Dish < ApplicationRecord
  enum :status, active: 0, inactive: 5

  has_one_attached :illustration
  has_many :portions, as: :portionable
  has_many :dish_infos
  has_many :dish_tags, through: :dish_infos
  accepts_nested_attributes_for :dish_tags, reject_if: lambda { |attributes| attributes['description'].blank? }

  belongs_to :restaurant

  validates :name, :description, presence: true
  validates :name, uniqueness: true
end
