require 'rails_helper'

RSpec.describe "managers/new", type: :view do
  before(:each) do
    assign(:manager, Manager.new(
      company: nil,
      person: nil,
      email: "MyString",
      job: "MyString",
      active: false
    ))
  end

  it "renders new manager form" do
    render

    assert_select "form[action=?][method=?]", managers_path, "post" do

      assert_select "input[name=?]", "manager[company_id]"

      assert_select "input[name=?]", "manager[person_id]"

      assert_select "input[name=?]", "manager[email]"

      assert_select "input[name=?]", "manager[job]"

      assert_select "input[name=?]", "manager[active]"
    end
  end
end
