class CourseHoursTurn < ApplicationRecord
  belongs_to :course_type_unit

  def self.generate_hours_turn(course_type_unit_id)
    course_type_unit = CourseTypeUnit.find(course_type_unit_id)

    if course_type_unit.is_by_turn
      turn_hour = course_type_unit.start_hour
      while turn_hour < course_type_unit.end_hour
        course_type_unit.course_hours_turns.create(
          hour: turn_hour
        )
       turn_hour += course_type_unit.shift_time.minutes
      end
    end
  end
end
