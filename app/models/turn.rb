class Turn < ApplicationRecord
  belongs_to :course
  belongs_to :person
  belongs_to :unit
  belongs_to :course_unit
end
