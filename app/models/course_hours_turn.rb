class CourseHoursTurn < ApplicationRecord
  belongs_to :course_type_unit

  def generate_hours_turn
  end
end
