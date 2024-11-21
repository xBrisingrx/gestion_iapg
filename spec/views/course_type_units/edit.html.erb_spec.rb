require 'rails_helper'

RSpec.describe "course_type_units/edit", type: :view do
  let(:course_type_unit) {
    CourseTypeUnit.create!(
      course_type: nil,
      unit: nil,
      day: 1,
      is_by_turn: false,
      shift: "MyString",
      shift_time: 1
    )
  }

  before(:each) do
    assign(:course_type_unit, course_type_unit)
  end

  it "renders the edit course_type_unit form" do
    render

    assert_select "form[action=?][method=?]", course_type_unit_path(course_type_unit), "post" do

      assert_select "input[name=?]", "course_type_unit[course_type_id]"

      assert_select "input[name=?]", "course_type_unit[unit_id]"

      assert_select "input[name=?]", "course_type_unit[day]"

      assert_select "input[name=?]", "course_type_unit[is_by_turn]"

      assert_select "input[name=?]", "course_type_unit[shift]"

      assert_select "input[name=?]", "course_type_unit[shift_time]"
    end
  end
end
