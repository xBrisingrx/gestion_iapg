require 'rails_helper'

RSpec.describe "sectionals/index", type: :view do
  before(:each) do
    assign(:sectionals, [
      Sectional.create!(
        name: "Name",
        direction: "Direction",
        city: nil,
        province: nil,
        active: false
      ),
      Sectional.create!(
        name: "Name",
        direction: "Direction",
        city: nil,
        province: nil,
        active: false
      )
    ])
  end

  it "renders a list of sectionals" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Direction".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
  end
end
