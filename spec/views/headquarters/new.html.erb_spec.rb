require 'rails_helper'

RSpec.describe "headquarters/new", type: :view do
  before(:each) do
    assign(:headquarter, Headquarter.new(
      name: "MyString",
      description: "MyString",
      sectional: nil,
      province: nil,
      city: nil,
      can_make_psychometric: false,
      active: false
    ))
  end

  it "renders new headquarter form" do
    render

    assert_select "form[action=?][method=?]", headquarters_path, "post" do

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
