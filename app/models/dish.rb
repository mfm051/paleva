class Dish < ApplicationRecord
  enum :status, active: 0, inactive: 5

  belongs_to :restaurant

  has_one_attached :illustration
  has_many :portions, as: :portionable
  has_many :dish_infos
  has_many :dish_tags, through: :dish_infos
  accepts_nested_attributes_for :dish_tags, reject_if: lambda { |attributes| attributes['description'].blank? }
  has_many :menu_items, as: :itemable

  before_validation :find_or_initialize_tags

  validates :name, :description, presence: true
  validates :name, uniqueness: true

  private

  def find_or_initialize_tags
    self.dish_tags = self.dish_tags.map do |tag|
      DishTag.find_or_initialize_by(description: tag.description)
    end
  end
end
