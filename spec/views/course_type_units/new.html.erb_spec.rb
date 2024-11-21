require 'rails_helper'

RSpec.describe "course_type_units/new", type: :view do
  before(:each) do
    assign(:course_type_unit, CourseTypeUnit.new(
      course_type: nil,
      unit: nil,
      day: 1,
      is_by_turn: false,
      shift: "MyString",
      shift_time: 1
    ))
  end

  it "renders new course_type_unit form" do
    render

    assert_select "form[action=?][method=?]", course_type_units_path, "post" do

      assert_select "input[name=?]", "course_type_unit[course_type_id]"

      assert_select "input[name=?]", "course_type_unit[unit_id]"

      assert_select "input[name=?]", "course_type_unit[day]"

      assert_select "input[name=?]", "course_type_unit[is_by_turn]"

      assert_select "input[name=?]", "course_type_unit[shift]"

      assert_select "input[name=?]", "course_type_unit[shift_time]"
    end
  end
end
