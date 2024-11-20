require 'rails_helper'

RSpec.describe "sectors/edit", type: :view do
  let(:sector) {
    Sector.create!(
      name: "MyString",
      description: "MyString",
      active: false
    )
  }

  before(:each) do
    assign(:sector, sector)
  end

  it "renders the edit sector form" do
    render

    assert_select "form[action=?][method=?]", sector_path(sector), "post" do

      assert_select "input[name=?]", "sector[name]"

      assert_select "input[name=?]", "sector[description]"

      assert_select "input[name=?]", "sector[active]"
    end
  end
end
