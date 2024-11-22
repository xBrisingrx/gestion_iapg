require 'rails_helper'

RSpec.describe "course_units/edit", type: :view do
  let(:course_unit) {
    CourseUnit.create!(
      course: nil,
      unit: nil,
      instructor: nil,
      shift: "MyString",
      day: 1,
      shift_time: 1,
      list: 1
    )
  }

  before(:each) do
    assign(:course_unit, course_unit)
  end

  it "renders the edit course_unit form" do
    render

    assert_select "form[action=?][method=?]", course_unit_path(course_unit), "post" do

      assert_select "input[name=?]", "course_unit[course_id]"

      assert_select "input[name=?]", "course_unit[unit_id]"

      assert_select "input[name=?]", "course_unit[instructor_id]"

      assert_select "input[name=?]", "course_unit[shift]"

      assert_select "input[name=?]", "course_unit[day]"

      assert_select "input[name=?]", "course_unit[shift_time]"

      assert_select "input[name=?]", "course_unit[list]"
    end
  end
end
