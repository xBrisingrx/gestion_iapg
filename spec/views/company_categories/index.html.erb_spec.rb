require 'rails_helper'

RSpec.describe "company_categories/index", type: :view do
  before(:each) do
    assign(:company_categories, [
      CompanyCategory.create!(
        name: "Name",
        description: "Description",
        quota: 2,
        active: false
      ),
      CompanyCategory.create!(
        name: "Name",
        description: "Description",
        quota: 2,
        active: false
      )
    ])
  end

  it "renders a list of company_categories" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Description".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
  end
end
