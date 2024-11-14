require 'rails_helper'

RSpec.describe "company_categories/edit", type: :view do
  let(:company_category) {
    CompanyCategory.create!(
      name: "MyString",
      description: "MyString",
      quota: 1,
      active: false
    )
  }

  before(:each) do
    assign(:company_category, company_category)
  end

  it "renders the edit company_category form" do
    render

    assert_select "form[action=?][method=?]", company_category_path(company_category), "post" do

      assert_select "input[name=?]", "company_category[name]"

      assert_select "input[name=?]", "company_category[description]"

      assert_select "input[name=?]", "company_category[quota]"

      assert_select "input[name=?]", "company_category[active]"
    end
  end
end
