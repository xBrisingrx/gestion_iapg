require 'rails_helper'

RSpec.describe "courses/show", type: :view do
  before(:each) do
    assign(:course, Course.create!(
      year_number: 2,
      general_number: 3,
      is_company: false,
      course_type: nil,
      room: nil,
      company: nil,
      active: false,
      code: "Code"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Code/)
  end
end
