require 'rails_helper'

RSpec.describe "course_units/index", type: :view do
  before(:each) do
    assign(:course_units, [
      CourseUnit.create!(
        course: nil,
        unit: nil,
        instructor: nil,
        shift: "Shift",
        day: 2,
        shift_time: 3,
        list: 4
      ),
      CourseUnit.create!(
        course: nil,
        unit: nil,
        instructor: nil,
        shift: "Shift",
        day: 2,
        shift_time: 3,
        list: 4
      )
    ])
  end

  it "renders a list of course_units" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Shift".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(3.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(4.to_s), count: 2
  end
end
