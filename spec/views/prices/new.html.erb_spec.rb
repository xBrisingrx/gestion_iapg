require 'rails_helper'

RSpec.describe "prices/new", type: :view do
  before(:each) do
    assign(:price, Price.new(
      price: 1,
      unit: nil,
      client_type: 1,
      sectional: nil,
      company: nil,
      active: false
    ))
  end

  it "renders new price form" do
    render

    assert_select "form[action=?][method=?]", prices_path, "post" do

      assert_select "input[name=?]", "price[price]"

      assert_select "input[name=?]", "price[unit_id]"

      assert_select "input[name=?]", "price[client_type]"

      assert_select "input[name=?]", "price[sectional_id]"

      assert_select "input[name=?]", "price[company_id]"

      assert_select "input[name=?]", "price[active]"
    end
  end
end
