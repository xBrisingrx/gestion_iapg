require "rails_helper"

RSpec.describe "CompanyCategories", type: :system do
  it "show rows in table" do
    create(:company_category)
    visit company_categories_path
    trs = find_all("tr")
    expect(trs.size).to eq(2)

    tbody = find("tbody")
    within tbody do
      tds = find_all("td")
      ths = find_all("th")
      expect(tds.size).to eq(tds.size)
    end
  end

  it "show form in modal" do
    visit company_categories_path
    click_on "Registrar categoría"
    expect(page).to have_css("h4", text:"Nueva categoría")
  end
end
