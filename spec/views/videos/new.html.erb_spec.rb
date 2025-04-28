require 'rails_helper'

RSpec.describe "videos/new", type: :view do
  before(:each) do
    assign(:video, Video.new(
      title: "MyString",
      file: "MyString",
      vimeo: "MyString",
      code: "MyString",
      active: false
    ))
  end

  it "renders new video form" do
    render

    assert_select "form[action=?][method=?]", videos_path, "post" do

      assert_select "input[name=?]", "video[title]"

      assert_select "input[name=?]", "video[file]"

      assert_select "input[name=?]", "video[vimeo]"

      assert_select "input[name=?]", "video[code]"

      assert_select "input[name=?]", "video[active]"
    end
  end
end
