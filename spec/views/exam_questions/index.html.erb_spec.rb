require 'rails_helper'

RSpec.describe "exam_questions/index", type: :view do
  before(:each) do
    assign(:exam_questions, [
      ExamQuestion.create!(
        exam: nil,
        question: nil,
        order: "Order",
        active: false
      ),
      ExamQuestion.create!(
        exam: nil,
        question: nil,
        order: "Order",
        active: false
      )
    ])
  end

  it "renders a list of exam_questions" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Order".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
  end
end
