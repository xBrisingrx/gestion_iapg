require 'rails_helper'

RSpec.describe "course_people/index", type: :view do
  before(:each) do
    assign(:course_people, [
      CoursePerson.create!(
        course: nil,
        person: nil,
        company: nil,
        inscription_motive: nil,
        fleet_category: nil,
        unit: nil,
        course_unit: nil,
        active: false
      ),
      CoursePerson.create!(
        course: nil,
        person: nil,
        company: nil,
        inscription_motive: nil,
        fleet_category: nil,
        unit: nil,
        course_unit: nil,
        active: false
      )
    ])
  end

  it "renders a list of course_people" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
  end
end
