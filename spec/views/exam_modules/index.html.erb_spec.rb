require 'rails_helper'

RSpec.describe "exam_modules/index", type: :view do
  before(:each) do
    assign(:exam_modules, [
      ExamModule.create!(
        exam: nil,
        name: "Name",
        quote_type: "Quote Type",
        module_order: 2
      ),
      ExamModule.create!(
        exam: nil,
        name: "Name",
        quote_type: "Quote Type",
        module_order: 2
      )
    ])
  end

  it "renders a list of exam_modules" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Quote Type".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
  end
end
