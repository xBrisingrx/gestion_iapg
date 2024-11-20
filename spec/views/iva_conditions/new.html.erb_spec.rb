require 'rails_helper'

RSpec.describe "iva_conditions/new", type: :view do
  before(:each) do
    assign(:iva_condition, IvaCondition.new(
      name: "MyString",
      description: "MyString",
      active: false
    ))
  end

  it "renders new iva_condition form" do
    render

    assert_select "form[action=?][method=?]", iva_conditions_path, "post" do

      assert_select "input[name=?]", "iva_condition[name]"

      assert_select "input[name=?]", "iva_condition[description]"

      assert_select "input[name=?]", "iva_condition[active]"
    end
  end
end
