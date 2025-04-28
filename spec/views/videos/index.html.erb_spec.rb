require 'rails_helper'

RSpec.describe "videos/index", type: :view do
  before(:each) do
    assign(:videos, [
      Video.create!(
        title: "Title",
        file: "File",
        vimeo: "Vimeo",
        code: "Code",
        active: false
      ),
      Video.create!(
        title: "Title",
        file: "File",
        vimeo: "Vimeo",
        code: "Code",
        active: false
      )
    ])
  end

  it "renders a list of videos" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Title".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("File".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Vimeo".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Code".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
  end
end
