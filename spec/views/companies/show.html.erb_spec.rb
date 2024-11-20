require 'rails_helper'

RSpec.describe "companies/show", type: :view do
  before(:each) do
    assign(:company, Company.create!(
      name: "Name",
      cuit: "Cuit",
      direction: "Direction",
      phone: "Phone",
      operator: false,
      comment: "Comment",
      iva_condition: nil,
      company_category: nil,
      sector: nil,
      province: nil,
      city: nil,
      active: false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Cuit/)
    expect(rendered).to match(/Direction/)
    expect(rendered).to match(/Phone/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Comment/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/false/)
  end
end
