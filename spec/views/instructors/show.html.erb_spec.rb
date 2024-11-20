require 'rails_helper'

RSpec.describe "instructors/show", type: :view do
  before(:each) do
    assign(:instructor, Instructor.create!(
      person: nil,
      theoretical: false,
      practical: false,
      code: "Code"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Code/)
  end
end
