require 'rails_helper'

RSpec.describe "company_categories/show", type: :view do
  before(:each) do
    assign(:company_category, CompanyCategory.create!(
      name: "Name",
      description: "Description",
      quota: 2,
      active: true
    ))
  end

  it "renders attributes in <tr>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/2/)
  end
end
