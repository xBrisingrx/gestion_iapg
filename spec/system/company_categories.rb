require "rails_helper"

RSpec.describe "CompanyCategories", type: :system do
  it "show rows in table" do
    create(:company_category)
    visit company_categories_path
    trs = find_all("tr")
    expect(trs.size).to eq(2)

    tbody = find("tbody")
    ths = find_all("th")
    within tbody do
      tds = find_all("td")
      expect(tds.size).to eq(ths.size)
    end
  end

  it "show form in modal" do
    visit company_categories_path
    click_on "Registrar categoría"
    expect(page).to have_css("h4", text: "Nueva categoría")
  end

  describe "Searching" do
    before do
      create(:company_category)
    end

    context "with not found search" do
      it "return not found results" do
        visit company_categories_path

        within "form" do
          fill_in "query", with: "hakunamatata"
          sleep 2
        end

        expect(page).to have_current_path(company_categories_path)
        expect(page).to have_css("td", text: "No hay información para mostrar")
      end
    end

    context "with found search" do
      it "return found results" do
        visit company_categories_path

        within "form" do
          fill_in "query", with: "autonomo"
          sleep 2
        end
        expect(page).to have_current_path(company_categories_path)

        within "tbody" do
          expect(page).to have_css("td", text: "Autonomo")
        end
      end
    end
  end
end
