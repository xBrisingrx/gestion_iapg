require 'rails_helper'

RSpec.describe "units/index", type: :view do
  before(:each) do
    assign(:units, [
      Unit.create!(
        name: "Name",
        description: "Description",
        fleet: "Fleet",
        methodology: "Methodology",
        category: "Category",
        active: false
      ),
      Unit.create!(
        name: "Name",
        description: "Description",
        fleet: "Fleet",
        methodology: "Methodology",
        category: "Category",
        active: false
      )
    ])
  end

  it "renders a list of units" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Description".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Fleet".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Methodology".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Category".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
  end
end
