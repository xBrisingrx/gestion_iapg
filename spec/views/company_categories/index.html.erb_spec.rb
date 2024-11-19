require 'rails_helper'

RSpec.describe "company_categories/index", type: :view do
  before(:each) do
    assign(:company_categories, [
      CompanyCategory.create!(
        name: "Name-1",
        description: "Description",
        quota: 1,
        active: true
      )
    ])
  end

  it "table have same theader that row attributes" do
    render
    cell_selector_thed = "thead>tr>th"
    cell_selector_tr = "tbody>tr>td"
    assert_select cell_selector_thed, count: 4
    assert_select cell_selector_tr, count: 4
  end
end
