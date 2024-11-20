require 'rails_helper'

RSpec.describe "instructors/edit", type: :view do
  let(:instructor) {
    Instructor.create!(
      person: nil,
      theoretical: false,
      practical: false,
      code: "MyString"
    )
  }

  before(:each) do
    assign(:instructor, instructor)
  end

  it "renders the edit instructor form" do
    render

    assert_select "form[action=?][method=?]", instructor_path(instructor), "post" do

      assert_select "input[name=?]", "instructor[person_id]"

      assert_select "input[name=?]", "instructor[theoretical]"

      assert_select "input[name=?]", "instructor[practical]"

      assert_select "input[name=?]", "instructor[code]"
    end
  end
end
