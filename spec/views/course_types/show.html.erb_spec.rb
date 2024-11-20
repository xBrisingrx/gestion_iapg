require 'rails_helper'

RSpec.describe "course_types/show", type: :view do
  before(:each) do
    assign(:course_type, CourseType.create!(
      name: "Name",
      description: "Description",
      min_quota: 2,
      max_quota: 3,
      min_score: 4,
      max_score: 5,
      passing_score: 6,
      number_of_repeat: 7,
      room: nil,
      active: false,
      category: "Category"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/5/)
    expect(rendered).to match(/6/)
    expect(rendered).to match(/7/)
    expect(rendered).to match(//)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Category/)
  end
end
