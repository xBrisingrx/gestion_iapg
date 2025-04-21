require 'rails_helper'

RSpec.describe "questions/edit", type: :view do
  let(:question) {
    Question.create!(
      question: "MyString",
      eliminating: false,
      active: false
    )
  }

  before(:each) do
    assign(:question, question)
  end

  it "renders the edit question form" do
    render

    assert_select "form[action=?][method=?]", question_path(question), "post" do

      assert_select "input[name=?]", "question[question]"

      assert_select "input[name=?]", "question[eliminating]"

      assert_select "input[name=?]", "question[active]"
    end
  end
end
