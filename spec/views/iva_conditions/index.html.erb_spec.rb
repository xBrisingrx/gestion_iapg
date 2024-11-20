require 'rails_helper'

RSpec.describe "iva_conditions/index", type: :view do
  before(:each) do
    assign(:iva_conditions, [
      IvaCondition.create!(
        name: "Name",
        description: "Description",
        active: false
      ),
      IvaCondition.create!(
        name: "Name",
        description: "Description",
        active: false
      )
    ])
  end

  it "renders a list of iva_conditions" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Description".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
  end
end
