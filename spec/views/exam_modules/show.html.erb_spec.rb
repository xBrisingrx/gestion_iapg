require 'rails_helper'

RSpec.describe "exam_modules/show", type: :view do
  before(:each) do
    assign(:exam_module, ExamModule.create!(
      exam: nil,
      name: "Name",
      quote_type: "Quote Type",
      module_order: 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Quote Type/)
    expect(rendered).to match(/2/)
  end
end
