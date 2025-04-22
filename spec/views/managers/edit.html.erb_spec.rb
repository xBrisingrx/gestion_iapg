require 'rails_helper'

RSpec.describe "managers/edit", type: :view do
  let(:manager) {
    Manager.create!(
      company: nil,
      person: nil,
      email: "MyString",
      job: "MyString",
      active: false
    )
  }

  before(:each) do
    assign(:manager, manager)
  end

  it "renders the edit manager form" do
    render

    assert_select "form[action=?][method=?]", manager_path(manager), "post" do

      assert_select "input[name=?]", "manager[company_id]"

      assert_select "input[name=?]", "manager[person_id]"

      assert_select "input[name=?]", "manager[email]"

      assert_select "input[name=?]", "manager[job]"

      assert_select "input[name=?]", "manager[active]"
    end
  end
end
