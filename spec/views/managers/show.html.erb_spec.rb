require 'rails_helper'

RSpec.describe "managers/show", type: :view do
  before(:each) do
    assign(:manager, Manager.create!(
      company: nil,
      person: nil,
      email: "Email",
      job: "Job",
      active: false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Job/)
    expect(rendered).to match(/false/)
  end
end
