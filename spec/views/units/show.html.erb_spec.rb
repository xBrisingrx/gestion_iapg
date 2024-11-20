require 'rails_helper'

RSpec.describe "units/show", type: :view do
  before(:each) do
    assign(:unit, Unit.create!(
      name: "Name",
      description: "Description",
      fleet: "Fleet",
      methodology: "Methodology",
      category: "Category",
      active: false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/Fleet/)
    expect(rendered).to match(/Methodology/)
    expect(rendered).to match(/Category/)
    expect(rendered).to match(/false/)
  end
end
