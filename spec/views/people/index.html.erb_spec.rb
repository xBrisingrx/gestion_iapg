require 'rails_helper'

RSpec.describe "people/index", type: :view do
  before(:each) do
    assign(:people, [
      Person.create!(
        cuil: 2,
        last_name: "Last Name",
        name: "Name",
        birthdate: "Birthdate",
        phone: "Phone",
        celphone: "Celphone",
        email: "Email",
        direction: "Direction",
        code: "Code",
        province: nil,
        city: nil,
        active: false
      ),
      Person.create!(
        cuil: 2,
        last_name: "Last Name",
        name: "Name",
        birthdate: "Birthdate",
        phone: "Phone",
        celphone: "Celphone",
        email: "Email",
        direction: "Direction",
        code: "Code",
        province: nil,
        city: nil,
        active: false
      )
    ])
  end

  it "renders a list of people" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Last Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Birthdate".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Phone".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Celphone".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Email".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Direction".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Code".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
  end
end
