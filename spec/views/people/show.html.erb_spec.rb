require 'rails_helper'

RSpec.describe "people/show", type: :view do
  before(:each) do
    assign(:person, Person.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Last Name/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Birthdate/)
    expect(rendered).to match(/Phone/)
    expect(rendered).to match(/Celphone/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Direction/)
    expect(rendered).to match(/Code/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/false/)
  end
end
