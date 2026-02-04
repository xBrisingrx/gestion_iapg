require 'rails_helper'

RSpec.describe "invoices/edit", type: :view do
  let(:invoice) {
    Invoice.create!(
      number: "MyString",
      company: nil,
      status: 1,
      detail: "MyString",
      active: false
    )
  }

  before(:each) do
    assign(:invoice, invoice)
  end

  it "renders the edit invoice form" do
    render

    assert_select "form[action=?][method=?]", invoice_path(invoice), "post" do

      assert_select "input[name=?]", "invoice[number]"

      assert_select "input[name=?]", "invoice[company_id]"

      assert_select "input[name=?]", "invoice[status]"

      assert_select "input[name=?]", "invoice[detail]"

      assert_select "input[name=?]", "invoice[active]"
    end
  end
end
