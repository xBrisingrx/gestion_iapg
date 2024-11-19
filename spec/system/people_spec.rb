require "rails_helper"

RSpec.describe "People", type: :system do
  it "renders index page" do
    create(:person)

    visit people_path

    within "main" do
      expect(page).to have_link "Registrar persona"
    end

    rows = find_all("tr")
    expect(rows.size).to eq(2)

    within "tbody" do
      td = find_all("td")
      expect(td[2]).to have_text("Eragon")
    end
  end
end
