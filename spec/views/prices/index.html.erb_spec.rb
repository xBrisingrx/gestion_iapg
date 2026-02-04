require 'rails_helper'

RSpec.describe "prices/index", type: :view do
  before(:each) do
    assign(:prices, [
      Price.create!(
        price: 2,
        unit: nil,
        client_type: 3,
        sectional: nil,
        company: nil,
        active: false
      ),
      Price.create!(
        price: 2,
        unit: nil,
        client_type: 3,
        sectional: nil,
        company: nil,
        active: false
      )
    ])
  end

  it "renders a list of prices" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(3.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
  end
end
