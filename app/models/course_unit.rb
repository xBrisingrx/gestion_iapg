class CourseUnit < ApplicationRecord
  belongs_to :course
  belongs_to :unit
  belongs_to :instructor
end
