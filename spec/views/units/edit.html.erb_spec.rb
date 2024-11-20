require 'rails_helper'

RSpec.describe "units/edit", type: :view do
  let(:unit) {
    Unit.create!(
      name: "MyString",
      description: "MyString",
      fleet: "MyString",
      methodology: "MyString",
      category: "MyString",
      active: false
    )
  }

  before(:each) do
    assign(:unit, unit)
  end

  it "renders the edit unit form" do
    render

    assert_select "form[action=?][method=?]", unit_path(unit), "post" do

      assert_select "input[name=?]", "unit[name]"

      assert_select "input[name=?]", "unit[description]"

      assert_select "input[name=?]", "unit[fleet]"

      assert_select "input[name=?]", "unit[methodology]"

      assert_select "input[name=?]", "unit[category]"

      assert_select "input[name=?]", "unit[active]"
    end
  end
end
