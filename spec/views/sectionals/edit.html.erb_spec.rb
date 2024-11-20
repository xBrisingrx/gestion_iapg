require 'rails_helper'

RSpec.describe "sectionals/edit", type: :view do
  let(:sectional) {
    Sectional.create!(
      name: "MyString",
      direction: "MyString",
      city: nil,
      province: nil,
      active: false
    )
  }

  before(:each) do
    assign(:sectional, sectional)
  end

  it "renders the edit sectional form" do
    render

    assert_select "form[action=?][method=?]", sectional_path(sectional), "post" do

      assert_select "input[name=?]", "sectional[name]"

      assert_select "input[name=?]", "sectional[direction]"

      assert_select "input[name=?]", "sectional[city_id]"

      assert_select "input[name=?]", "sectional[province_id]"

      assert_select "input[name=?]", "sectional[active]"
    end
  end
end
