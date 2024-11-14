require 'rails_helper'

RSpec.describe "people/new", type: :view do
  before(:each) do
    assign(:person, Person.new(
      cuil: 1,
      last_name: "MyString",
      name: "MyString",
      birthdate: "MyString",
      phone: "MyString",
      celphone: "MyString",
      email: "MyString",
      direction: "MyString",
      code: "MyString",
      province: nil,
      city: nil,
      active: false
    ))
  end

  it "renders new person form" do
    render

    assert_select "form[action=?][method=?]", people_path, "post" do

      assert_select "input[name=?]", "person[cuil]"

      assert_select "input[name=?]", "person[last_name]"

      assert_select "input[name=?]", "person[name]"

      assert_select "input[name=?]", "person[birthdate]"

      assert_select "input[name=?]", "person[phone]"

      assert_select "input[name=?]", "person[celphone]"

      assert_select "input[name=?]", "person[email]"

      assert_select "input[name=?]", "person[direction]"

      assert_select "input[name=?]", "person[code]"

      assert_select "input[name=?]", "person[province_id]"

      assert_select "input[name=?]", "person[city_id]"

      assert_select "input[name=?]", "person[active]"
    end
  end
end
