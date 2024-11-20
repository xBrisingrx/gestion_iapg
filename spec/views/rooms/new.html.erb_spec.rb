require 'rails_helper'

RSpec.describe "rooms/new", type: :view do
  before(:each) do
    assign(:room, Room.new(
      name: "MyString",
      description: "MyString",
      capacity: 1,
      headquarter: nil,
      active: false
    ))
  end

  it "renders new room form" do
    render

    assert_select "form[action=?][method=?]", rooms_path, "post" do

      assert_select "input[name=?]", "room[name]"

      assert_select "input[name=?]", "room[description]"

      assert_select "input[name=?]", "room[capacity]"

      assert_select "input[name=?]", "room[headquarter_id]"

      assert_select "input[name=?]", "room[active]"
    end
  end
end
