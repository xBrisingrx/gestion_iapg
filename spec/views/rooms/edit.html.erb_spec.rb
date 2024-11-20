require 'rails_helper'

RSpec.describe "rooms/edit", type: :view do
  let(:room) {
    Room.create!(
      name: "MyString",
      description: "MyString",
      capacity: 1,
      headquarter: nil,
      active: false
    )
  }

  before(:each) do
    assign(:room, room)
  end

  it "renders the edit room form" do
    render

    assert_select "form[action=?][method=?]", room_path(room), "post" do

      assert_select "input[name=?]", "room[name]"

      assert_select "input[name=?]", "room[description]"

      assert_select "input[name=?]", "room[capacity]"

      assert_select "input[name=?]", "room[headquarter_id]"

      assert_select "input[name=?]", "room[active]"
    end
  end
end
