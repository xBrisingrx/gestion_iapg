require 'rails_helper'

RSpec.describe "invoices/new", type: :view do
  before(:each) do
    assign(:invoice, Invoice.new(
      number: "MyString",
      company: nil,
      status: 1,
      detail: "MyString",
      active: false
    ))
  end

  it "renders new invoice form" do
    render

    assert_select "form[action=?][method=?]", invoices_path, "post" do

      assert_select "input[name=?]", "invoice[number]"

      assert_select "input[name=?]", "invoice[company_id]"

      assert_select "input[name=?]", "invoice[status]"

      assert_select "input[name=?]", "invoice[detail]"

      assert_select "input[name=?]", "invoice[active]"
    end
  end
end
