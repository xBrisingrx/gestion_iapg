class CoursePerson < ApplicationRecord
  belongs_to :course
  belongs_to :person
  belongs_to :company
  belongs_to :inscription_motive
  belongs_to :fleet_category
  belongs_to :unit
  belongs_to :course_unit
end
