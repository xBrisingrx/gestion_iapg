require 'rails_helper'

RSpec.describe "headquarters/index", type: :view do
  before(:each) do
    assign(:headquarters, [
      Headquarter.create!(
        name: "Name",
        description: "Description",
        sectional: nil,
        province: nil,
        city: nil,
        can_make_psychometric: false,
        active: false
      ),
      Headquarter.create!(
        name: "Name",
        description: "Description",
        sectional: nil,
        province: nil,
        city: nil,
        can_make_psychometric: false,
        active: false
      )
    ])
  end

  it "renders a list of headquarters" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Description".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
  end
end
