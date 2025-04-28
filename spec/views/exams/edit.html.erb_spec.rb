require 'rails_helper'

RSpec.describe "exams/edit", type: :view do
  let(:exam) {
    Exam.create!(
      title: "MyString",
      video: false,
      retake: 1,
      elearning: false,
      active: false
    )
  }

  before(:each) do
    assign(:exam, exam)
  end

  it "renders the edit exam form" do
    render

    assert_select "form[action=?][method=?]", exam_path(exam), "post" do

      assert_select "input[name=?]", "exam[title]"

      assert_select "input[name=?]", "exam[video]"

      assert_select "input[name=?]", "exam[retake]"

      assert_select "input[name=?]", "exam[elearning]"

      assert_select "input[name=?]", "exam[active]"
    end
  end
end
