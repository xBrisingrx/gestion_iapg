require 'rails_helper'

RSpec.describe "companies/index", type: :view do
  before(:each) do
    assign(:companies, [
      Company.create!(
        name: "Name",
        cuit: "Cuit",
        direction: "Direction",
        phone: "Phone",
        operator: false,
        comment: "Comment",
        iva_condition: nil,
        company_category: nil,
        sector: nil,
        province: nil,
        city: nil,
        active: false
      ),
      Company.create!(
        name: "Name",
        cuit: "Cuit",
        direction: "Direction",
        phone: "Phone",
        operator: false,
        comment: "Comment",
        iva_condition: nil,
        company_category: nil,
        sector: nil,
        province: nil,
        city: nil,
        active: false
      )
    ])
  end

  it "renders a list of companies" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Cuit".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Direction".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Phone".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Comment".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
  end
end
