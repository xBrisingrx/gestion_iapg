require 'rails_helper'

RSpec.describe "answers/show", type: :view do
  before(:each) do
    assign(:answer, Answer.create!(
      answer: "Answer",
      correct: false,
      order: 2,
      active: false,
      question: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Answer/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(//)
  end
end
