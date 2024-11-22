require 'rails_helper'

RSpec.describe "courses/edit", type: :view do
  let(:course) {
    Course.create!(
      year_number: 1,
      general_number: 1,
      is_company: false,
      course_type: nil,
      room: nil,
      company: nil,
      active: false,
      code: "MyString"
    )
  }

  before(:each) do
    assign(:course, course)
  end

  it "renders the edit course form" do
    render

    assert_select "form[action=?][method=?]", course_path(course), "post" do

      assert_select "input[name=?]", "course[year_number]"

      assert_select "input[name=?]", "course[general_number]"

      assert_select "input[name=?]", "course[is_company]"

      assert_select "input[name=?]", "course[course_type_id]"

      assert_select "input[name=?]", "course[room_id]"

      assert_select "input[name=?]", "course[company_id]"

      assert_select "input[name=?]", "course[active]"

      assert_select "input[name=?]", "course[code]"
    end
  end
end
