require 'rails_helper'

RSpec.describe "exams/new", type: :view do
  before(:each) do
    assign(:exam, Exam.new(
      title: "MyString",
      video: false,
      retake: 1,
      elearning: false,
      active: false
    ))
  end

  it "renders new exam form" do
    render

    assert_select "form[action=?][method=?]", exams_path, "post" do

      assert_select "input[name=?]", "exam[title]"

      assert_select "input[name=?]", "exam[video]"

      assert_select "input[name=?]", "exam[retake]"

      assert_select "input[name=?]", "exam[elearning]"

      assert_select "input[name=?]", "exam[active]"
    end
  end
end
