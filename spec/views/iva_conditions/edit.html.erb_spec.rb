require 'rails_helper'

RSpec.describe "iva_conditions/edit", type: :view do
  let(:iva_condition) {
    IvaCondition.create!(
      name: "MyString",
      description: "MyString",
      active: false
    )
  }

  before(:each) do
    assign(:iva_condition, iva_condition)
  end

  it "renders the edit iva_condition form" do
    render

    assert_select "form[action=?][method=?]", iva_condition_path(iva_condition), "post" do

      assert_select "input[name=?]", "iva_condition[name]"

      assert_select "input[name=?]", "iva_condition[description]"

      assert_select "input[name=?]", "iva_condition[active]"
    end
  end
end
