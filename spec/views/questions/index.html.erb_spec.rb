require 'rails_helper'

RSpec.describe "questions/index", type: :view do
  before(:each) do
    assign(:questions, [
      Question.create!(
        question: "Question",
        eliminating: false,
        active: false
      ),
      Question.create!(
        question: "Question",
        eliminating: false,
        active: false
      )
    ])
  end

  it "renders a list of questions" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Question".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
  end
end
