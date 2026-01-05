class Seat < ApplicationRecord
  belongs_to :company
  belongs_to :person
  belongs_to :courses
end
