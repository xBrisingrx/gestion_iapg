require 'rails_helper'

RSpec.describe "invoices/show", type: :view do
  before(:each) do
    assign(:invoice, Invoice.create!(
      number: "Number",
      company: nil,
      status: 2,
      detail: "Detail",
      active: false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Number/)
    expect(rendered).to match(//)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Detail/)
    expect(rendered).to match(/false/)
  end
end
