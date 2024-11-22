require 'rails_helper'

RSpec.describe "course_units/show", type: :view do
  before(:each) do
    assign(:course_unit, CourseUnit.create!(
      course: nil,
      unit: nil,
      instructor: nil,
      shift: "Shift",
      day: 2,
      shift_time: 3,
      list: 4
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/Shift/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
  end
end
