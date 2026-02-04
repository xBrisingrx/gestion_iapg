require 'rails_helper'

RSpec.describe "prices/edit", type: :view do
  let(:price) {
    Price.create!(
      price: 1,
      unit: nil,
      client_type: 1,
      sectional: nil,
      company: nil,
      active: false
    )
  }

  before(:each) do
    assign(:price, price)
  end

  it "renders the edit price form" do
    render

    assert_select "form[action=?][method=?]", price_path(price), "post" do

      assert_select "input[name=?]", "price[price]"

      assert_select "input[name=?]", "price[unit_id]"

      assert_select "input[name=?]", "price[client_type]"

      assert_select "input[name=?]", "price[sectional_id]"

      assert_select "input[name=?]", "price[company_id]"

      assert_select "input[name=?]", "price[active]"
    end
  end
end
