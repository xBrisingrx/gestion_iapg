require 'rails_helper'

RSpec.describe "answers/edit", type: :view do
  let(:answer) {
    Answer.create!(
      answer: "MyString",
      correct: false,
      order: 1,
      active: false,
      question: nil
    )
  }

  before(:each) do
    assign(:answer, answer)
  end

  it "renders the edit answer form" do
    render

    assert_select "form[action=?][method=?]", answer_path(answer), "post" do

      assert_select "input[name=?]", "answer[answer]"

      assert_select "input[name=?]", "answer[correct]"

      assert_select "input[name=?]", "answer[order]"

      assert_select "input[name=?]", "answer[active]"

      assert_select "input[name=?]", "answer[question_id]"
    end
  end
end
