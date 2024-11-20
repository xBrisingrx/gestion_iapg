require 'rails_helper'

RSpec.describe "course_types/new", type: :view do
  before(:each) do
    assign(:course_type, CourseType.new(
      name: "MyString",
      description: "MyString",
      min_quota: 1,
      max_quota: 1,
      min_score: 1,
      max_score: 1,
      passing_score: 1,
      number_of_repeat: 1,
      room: nil,
      active: false,
      category: "MyString"
    ))
  end

  it "renders new course_type form" do
    render

    assert_select "form[action=?][method=?]", course_types_path, "post" do

      assert_select "input[name=?]", "course_type[name]"

      assert_select "input[name=?]", "course_type[description]"

      assert_select "input[name=?]", "course_type[min_quota]"

      assert_select "input[name=?]", "course_type[max_quota]"

      assert_select "input[name=?]", "course_type[min_score]"

      assert_select "input[name=?]", "course_type[max_score]"

      assert_select "input[name=?]", "course_type[passing_score]"

      assert_select "input[name=?]", "course_type[number_of_repeat]"

      assert_select "input[name=?]", "course_type[room_id]"

      assert_select "input[name=?]", "course_type[active]"

      assert_select "input[name=?]", "course_type[category]"
    end
  end
end
