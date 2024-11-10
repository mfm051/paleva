class MenuItem < ApplicationRecord
  belongs_to :menu
  belongs_to :itemable, polymorphic: true
end
