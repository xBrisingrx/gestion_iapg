require 'rails_helper'

RSpec.describe "instructors/index", type: :view do
  before(:each) do
    assign(:instructors, [
      Instructor.create!(
        person: nil,
        theoretical: false,
        practical: false,
        code: "Code"
      ),
      Instructor.create!(
        person: nil,
        theoretical: false,
        practical: false,
        code: "Code"
      )
    ])
  end

  it "renders a list of instructors" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Code".to_s), count: 2
  end
end
