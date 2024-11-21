require 'rails_helper'

RSpec.describe "course_type_units/index", type: :view do
  before(:each) do
    assign(:course_type_units, [
      CourseTypeUnit.create!(
        course_type: nil,
        unit: nil,
        day: 2,
        is_by_turn: false,
        shift: "Shift",
        shift_time: 3
      ),
      CourseTypeUnit.create!(
        course_type: nil,
        unit: nil,
        day: 2,
        is_by_turn: false,
        shift: "Shift",
        shift_time: 3
      )
    ])
  end

  it "renders a list of course_type_units" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Shift".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(3.to_s), count: 2
  end
end
