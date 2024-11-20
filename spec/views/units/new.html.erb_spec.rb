require 'rails_helper'

RSpec.describe "units/new", type: :view do
  before(:each) do
    assign(:unit, Unit.new(
      name: "MyString",
      description: "MyString",
      fleet: "MyString",
      methodology: "MyString",
      category: "MyString",
      active: false
    ))
  end

  it "renders new unit form" do
    render

    assert_select "form[action=?][method=?]", units_path, "post" do

      assert_select "input[name=?]", "unit[name]"

      assert_select "input[name=?]", "unit[description]"

      assert_select "input[name=?]", "unit[fleet]"

      assert_select "input[name=?]", "unit[methodology]"

      assert_select "input[name=?]", "unit[category]"

      assert_select "input[name=?]", "unit[active]"
    end
  end
end
