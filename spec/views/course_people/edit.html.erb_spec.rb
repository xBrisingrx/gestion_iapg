require 'rails_helper'

RSpec.describe "course_people/edit", type: :view do
  let(:course_person) {
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
  }

  before(:each) do
    assign(:course_person, course_person)
  end

  it "renders the edit course_person form" do
    render

    assert_select "form[action=?][method=?]", course_person_path(course_person), "post" do

      assert_select "input[name=?]", "course_person[course_id]"

      assert_select "input[name=?]", "course_person[person_id]"

      assert_select "input[name=?]", "course_person[company_id]"

      assert_select "input[name=?]", "course_person[inscription_motive_id]"

      assert_select "input[name=?]", "course_person[fleet_category_id]"

      assert_select "input[name=?]", "course_person[unit_id]"

      assert_select "input[name=?]", "course_person[course_unit_id]"

      assert_select "input[name=?]", "course_person[active]"
    end
  end
end
