require 'rails_helper'

RSpec.describe "course_people/show", type: :view do
  before(:each) do
    assign(:course_person, CoursePerson.create!(
      course: nil,
      person: nil,
      company: nil,
      inscription_motive: nil,
      fleet_category: nil,
      unit: nil,
      course_unit: nil,
      active: false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/false/)
  end
end
