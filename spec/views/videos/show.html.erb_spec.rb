require 'rails_helper'

RSpec.describe "videos/show", type: :view do
  before(:each) do
    assign(:video, Video.create!(
      title: "Title",
      file: "File",
      vimeo: "Vimeo",
      code: "Code",
      active: false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/File/)
    expect(rendered).to match(/Vimeo/)
    expect(rendered).to match(/Code/)
    expect(rendered).to match(/false/)
  end
end
