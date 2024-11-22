require 'rails_helper'

RSpec.describe "courses/index", type: :view do
  before(:each) do
    assign(:courses, [
      Course.create!(
        year_number: 2,
        general_number: 3,
        is_company: false,
        course_type: nil,
        room: nil,
        company: nil,
        active: false,
        code: "Code"
      ),
      Course.create!(
        year_number: 2,
        general_number: 3,
        is_company: false,
        course_type: nil,
        room: nil,
        company: nil,
        active: false,
        code: "Code"
      )
    ])
  end

  it "renders a list of courses" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(3.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Code".to_s), count: 2
  end
end
