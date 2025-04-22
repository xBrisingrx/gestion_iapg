require 'rails_helper'

RSpec.describe CourseTypeUnit, type: :model do
  describe "I can't add modules at the same time on the same day" do
    let (:course_type_unit) { create(:course_type_unit) }
    let (:overlapping_hour) { build(:course_type_unit, :overlapping_hour, course_type_id: course_type_unit.course_type_id) }
    let (:available_hours) { build(:course_type_unit, start_hour: "15:30", end_hour: "17:00", course_type_id: course_type_unit.course_type_id) }
    before do
      [ course_type_unit, overlapping_hour ]
    end
    it "record invalid if time lapse is busy" do
      expect(overlapping_hour).to be_invalid
    end

    it "record valid if time slot is free" do
      expect(available_hours).to be_valid
    end
  end
end
