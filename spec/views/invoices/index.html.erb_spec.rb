require 'rails_helper'

RSpec.describe "invoices/index", type: :view do
  before(:each) do
    assign(:invoices, [
      Invoice.create!(
        number: "Number",
        company: nil,
        status: 2,
        detail: "Detail",
        active: false
      ),
      Invoice.create!(
        number: "Number",
        company: nil,
        status: 2,
        detail: "Detail",
        active: false
      )
    ])
  end

  it "renders a list of invoices" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Number".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Detail".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
  end
end
