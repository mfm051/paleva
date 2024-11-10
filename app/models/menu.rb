class Menu < ApplicationRecord
  belongs_to :restaurant
  has_many :menu_items
  has_many :dishes, through: :menu_items, source: :itemable, source_type: 'Dish'
  has_many :drinks, through: :menu_items, source: :itemable, source_type: 'Drink'
end
