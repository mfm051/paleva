class DishInfo < ApplicationRecord
  belongs_to :dish
  belongs_to :dish_tag
end
