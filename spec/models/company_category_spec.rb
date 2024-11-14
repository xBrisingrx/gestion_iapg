require 'rails_helper'

RSpec.describe CompanyCategory, type: :model do
  subject { build(:company_category) }

  describe "validations" do
    it { is_expected.to be_valid }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:quota) }
    it { is_expected.to validate_uniqueness_of(:name).with_message("Esta categoría ya se encuentra registrada") }
  end

  describe "scope" do
    describe ".active" do
      let(:company_category1) { create(:company_category) }
      let(:company_category2) { create(:company_category, :inactive) }

      before do
        [ company_category1, company_category2 ]
      end
      it "return only active company categories" do
        expect(CompanyCategory.actives).to eq([ company_category1 ])
      end
    end

    describe ".filter" do
      let(:company_category1) { create(:company_category) }
      let(:company_category2) { create(:company_category, name: "Responsable inscripto", quota: 10) }

      before do
        [ company_category1, company_category2 ]
      end

      it "return category companies filter by name, description or quota" do
        expect(CompanyCategory.filter("auto")).to eq([ company_category1 ])
        expect(CompanyCategory.filter("monotributista")).to eq([ company_category1, company_category2 ])
        expect(CompanyCategory.filter("10")).to eq([ company_category2 ])
        expect(CompanyCategory.filter("abadacadabra")).to eq([ ])
      end # it
    end # describe filter
  end
end
