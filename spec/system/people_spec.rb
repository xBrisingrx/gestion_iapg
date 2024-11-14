require "rails_helper"

RSpec.describe "People", type: :system do
  it "renders index page" do
    visit people_path
    within "main" do
      expect(page).to have_link "Nueva persona"
    end
  end
end
