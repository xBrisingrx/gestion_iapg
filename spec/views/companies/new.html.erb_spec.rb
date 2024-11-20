require 'rails_helper'

RSpec.describe "companies/new", type: :view do
  before(:each) do
    assign(:company, Company.new(
      name: "MyString",
      cuit: "MyString",
      direction: "MyString",
      phone: "MyString",
      operator: false,
      comment: "MyString",
      iva_condition: nil,
      company_category: nil,
      sector: nil,
      province: nil,
      city: nil,
      active: false
    ))
  end

  it "renders new company form" do
    render

    assert_select "form[action=?][method=?]", companies_path, "post" do

      assert_select "input[name=?]", "company[name]"

      assert_select "input[name=?]", "company[cuit]"

      assert_select "input[name=?]", "company[direction]"

      assert_select "input[name=?]", "company[phone]"

      assert_select "input[name=?]", "company[operator]"

      assert_select "input[name=?]", "company[comment]"

      assert_select "input[name=?]", "company[iva_condition_id]"

      assert_select "input[name=?]", "company[company_category_id]"

      assert_select "input[name=?]", "company[sector_id]"

      assert_select "input[name=?]", "company[province_id]"

      assert_select "input[name=?]", "company[city_id]"

      assert_select "input[name=?]", "company[active]"
    end
  end
end
