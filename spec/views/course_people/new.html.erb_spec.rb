require 'rails_helper'

RSpec.describe "course_people/new", type: :view do
  before(:each) do
    assign(:course_person, CoursePerson.new(
      course: nil,
      person: nil,
      company: nil,
      inscription_motive: nil,
      fleet_category: nil,
      unit: nil,
      course_unit: nil,
      active: false
    ))
  end

  it "renders new course_person form" do
    render

    assert_select "form[action=?][method=?]", course_people_path, "post" do

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
