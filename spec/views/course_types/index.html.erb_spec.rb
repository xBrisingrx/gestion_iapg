require 'rails_helper'

RSpec.describe "course_types/index", type: :view do
  before(:each) do
    assign(:course_types, [
      CourseType.create!(
        name: "Name",
        description: "Description",
        min_quota: 2,
        max_quota: 3,
        min_score: 4,
        max_score: 5,
        passing_score: 6,
        number_of_repeat: 7,
        room: nil,
        active: false,
        category: "Category"
      ),
      CourseType.create!(
        name: "Name",
        description: "Description",
        min_quota: 2,
        max_quota: 3,
        min_score: 4,
        max_score: 5,
        passing_score: 6,
        number_of_repeat: 7,
        room: nil,
        active: false,
        category: "Category"
      )
    ])
  end

  it "renders a list of course_types" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Description".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(3.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(4.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(5.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(6.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(7.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Category".to_s), count: 2
  end
end
