require 'rails_helper'

RSpec.describe "sectionals/new", type: :view do
  before(:each) do
    assign(:sectional, Sectional.new(
      name: "MyString",
      direction: "MyString",
      city: nil,
      province: nil,
      active: false
    ))
  end

  it "renders new sectional form" do
    render

    assert_select "form[action=?][method=?]", sectionals_path, "post" do

      assert_select "input[name=?]", "sectional[name]"

      assert_select "input[name=?]", "sectional[direction]"

      assert_select "input[name=?]", "sectional[city_id]"

      assert_select "input[name=?]", "sectional[province_id]"

      assert_select "input[name=?]", "sectional[active]"
    end
  end
end
