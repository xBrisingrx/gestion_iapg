require 'rails_helper'

RSpec.describe "course_units/new", type: :view do
  before(:each) do
    assign(:course_unit, CourseUnit.new(
      course: nil,
      unit: nil,
      instructor: nil,
      shift: "MyString",
      day: 1,
      shift_time: 1,
      list: 1
    ))
  end

  it "renders new course_unit form" do
    render

    assert_select "form[action=?][method=?]", course_units_path, "post" do

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
