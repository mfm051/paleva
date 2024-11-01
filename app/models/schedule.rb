class Schedule < ApplicationRecord
  belongs_to :restaurant
  enum :weekday, [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday]
end
