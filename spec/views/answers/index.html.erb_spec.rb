require 'rails_helper'

RSpec.describe "answers/index", type: :view do
  before(:each) do
    assign(:answers, [
      Answer.create!(
        answer: "Answer",
        correct: false,
        order: 2,
        active: false,
        question: nil
      ),
      Answer.create!(
        answer: "Answer",
        correct: false,
        order: 2,
        active: false,
        question: nil
      )
    ])
  end

  it "renders a list of answers" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Answer".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
