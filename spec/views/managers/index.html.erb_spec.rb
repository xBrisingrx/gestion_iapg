require 'rails_helper'

RSpec.describe "managers/index", type: :view do
  before(:each) do
    assign(:managers, [
      Manager.create!(
        company: nil,
        person: nil,
        email: "Email",
        job: "Job",
        active: false
      ),
      Manager.create!(
        company: nil,
        person: nil,
        email: "Email",
        job: "Job",
        active: false
      )
    ])
  end

  it "renders a list of managers" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Email".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Job".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
  end
end
