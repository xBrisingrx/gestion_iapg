require 'rails_helper'

RSpec.describe "prices/show", type: :view do
  before(:each) do
    assign(:price, Price.create!(
      price: 2,
      unit: nil,
      client_type: 3,
      sectional: nil,
      company: nil,
      active: false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(//)
    expect(rendered).to match(/3/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/false/)
  end
end
