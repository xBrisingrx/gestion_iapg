require 'rails_helper'

RSpec.describe "sectors/new", type: :view do
  before(:each) do
    assign(:sector, Sector.new(
      name: "MyString",
      description: "MyString",
      active: false
    ))
  end

  it "renders new sector form" do
    render

    assert_select "form[action=?][method=?]", sectors_path, "post" do

      assert_select "input[name=?]", "sector[name]"

      assert_select "input[name=?]", "sector[description]"

      assert_select "input[name=?]", "sector[active]"
    end
  end
end
