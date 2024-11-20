require 'rails_helper'

RSpec.describe "instructors/new", type: :view do
  before(:each) do
    assign(:instructor, Instructor.new(
      person: nil,
      theoretical: false,
      practical: false,
      code: "MyString"
    ))
  end

  it "renders new instructor form" do
    render

    assert_select "form[action=?][method=?]", instructors_path, "post" do

      assert_select "input[name=?]", "instructor[person_id]"

      assert_select "input[name=?]", "instructor[theoretical]"

      assert_select "input[name=?]", "instructor[practical]"

      assert_select "input[name=?]", "instructor[code]"
    end
  end
end
