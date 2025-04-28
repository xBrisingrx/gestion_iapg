require 'rails_helper'

RSpec.describe "exam_modules/edit", type: :view do
  let(:exam_module) {
    ExamModule.create!(
      exam: nil,
      name: "MyString",
      quote_type: "MyString",
      module_order: 1
    )
  }

  before(:each) do
    assign(:exam_module, exam_module)
  end

  it "renders the edit exam_module form" do
    render

    assert_select "form[action=?][method=?]", exam_module_path(exam_module), "post" do

      assert_select "input[name=?]", "exam_module[exam_id]"

      assert_select "input[name=?]", "exam_module[name]"

      assert_select "input[name=?]", "exam_module[quote_type]"

      assert_select "input[name=?]", "exam_module[module_order]"
    end
  end
end
