require 'rails_helper'

RSpec.describe "videos/edit", type: :view do
  let(:video) {
    Video.create!(
      title: "MyString",
      file: "MyString",
      vimeo: "MyString",
      code: "MyString",
      active: false
    )
  }

  before(:each) do
    assign(:video, video)
  end

  it "renders the edit video form" do
    render

    assert_select "form[action=?][method=?]", video_path(video), "post" do

      assert_select "input[name=?]", "video[title]"

      assert_select "input[name=?]", "video[file]"

      assert_select "input[name=?]", "video[vimeo]"

      assert_select "input[name=?]", "video[code]"

      assert_select "input[name=?]", "video[active]"
    end
  end
end
