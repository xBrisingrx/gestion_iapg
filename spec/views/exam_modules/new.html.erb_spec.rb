require 'rails_helper'

RSpec.describe "exam_modules/new", type: :view do
  before(:each) do
    assign(:exam_module, ExamModule.new(
      exam: nil,
      name: "MyString",
      quote_type: "MyString",
      module_order: 1
    ))
  end

  it "renders new exam_module form" do
    render

    assert_select "form[action=?][method=?]", exam_modules_path, "post" do

      assert_select "input[name=?]", "exam_module[exam_id]"

      assert_select "input[name=?]", "exam_module[name]"

      assert_select "input[name=?]", "exam_module[quote_type]"

      assert_select "input[name=?]", "exam_module[module_order]"
    end
  end
end
