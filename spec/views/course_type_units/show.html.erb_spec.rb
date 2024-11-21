require 'rails_helper'

RSpec.describe "course_type_units/show", type: :view do
  before(:each) do
    assign(:course_type_unit, CourseTypeUnit.create!(
      course_type: nil,
      unit: nil,
      day: 2,
      is_by_turn: false,
      shift: "Shift",
      shift_time: 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Shift/)
    expect(rendered).to match(/3/)
  end
end
