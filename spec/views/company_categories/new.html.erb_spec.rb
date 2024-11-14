require 'rails_helper'

RSpec.describe "company_categories/new", type: :view do
  before(:each) do
    assign(:company_category, CompanyCategory.new(
      name: "MyString",
      description: "MyString",
      quota: 1,
      active: false
    ))
  end

  it "renders new company_category form" do
    render

    assert_select "form[action=?][method=?]", company_categories_path, "post" do

      assert_select "input[name=?]", "company_category[name]"

      assert_select "input[name=?]", "company_category[description]"

      assert_select "input[name=?]", "company_category[quota]"

      assert_select "input[name=?]", "company_category[active]"
    end
  end
end
