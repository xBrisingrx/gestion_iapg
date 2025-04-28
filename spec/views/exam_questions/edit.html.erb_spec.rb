require 'rails_helper'

RSpec.describe "exam_questions/edit", type: :view do
  let(:exam_question) {
    ExamQuestion.create!(
      exam: nil,
      question: nil,
      order: "MyString",
      active: false
    )
  }

  before(:each) do
    assign(:exam_question, exam_question)
  end

  it "renders the edit exam_question form" do
    render

    assert_select "form[action=?][method=?]", exam_question_path(exam_question), "post" do

      assert_select "input[name=?]", "exam_question[exam_id]"

      assert_select "input[name=?]", "exam_question[question_id]"

      assert_select "input[name=?]", "exam_question[order]"

      assert_select "input[name=?]", "exam_question[active]"
    end
  end
end
