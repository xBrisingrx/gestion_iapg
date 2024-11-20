require 'rails_helper'

RSpec.describe "sectionals/show", type: :view do
  before(:each) do
    assign(:sectional, Sectional.create!(
      name: "Name",
      direction: "Direction",
      city: nil,
      province: nil,
      active: false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Direction/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/false/)
  end
end
