require 'rails_helper'

RSpec.describe "exam_questions/show", type: :view do
  before(:each) do
    assign(:exam_question, ExamQuestion.create!(
      exam: nil,
      question: nil,
      order: "Order",
      active: false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/Order/)
    expect(rendered).to match(/false/)
  end
end
