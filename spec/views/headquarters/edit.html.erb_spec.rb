require 'rails_helper'

RSpec.describe "headquarters/edit", type: :view do
  let(:headquarter) {
    Headquarter.create!(
      name: "MyString",
      description: "MyString",
      sectional: nil,
      province: nil,
      city: nil,
      can_make_psychometric: false,
      active: false
    )
  }

  before(:each) do
    assign(:headquarter, headquarter)
  end

  it "renders the edit headquarter form" do
    render

    assert_select "form[action=?][method=?]", headquarter_path(headquarter), "post" do

      assert_select "input[name=?]", "headquarter[name]"

      assert_select "input[name=?]", "headquarter[description]"

      assert_select "input[name=?]", "headquarter[sectional_id]"

      assert_select "input[name=?]", "headquarter[province_id]"

      assert_select "input[name=?]", "headquarter[city_id]"

      assert_select "input[name=?]", "headquarter[can_make_psychometric]"

      assert_select "input[name=?]", "headquarter[active]"
    end
  end
end
