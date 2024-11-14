require "rails_helper"

RSpec.describe CompanyCategoriesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/company_categories").to route_to("company_categories#index")
    end

    it "routes to #new" do
      expect(get: "/company_categories/new").to route_to("company_categories#new")
    end

    it "routes to #show" do
      expect(get: "/company_categories/1").to route_to("company_categories#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/company_categories/1/edit").to route_to("company_categories#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/company_categories").to route_to("company_categories#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/company_categories/1").to route_to("company_categories#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/company_categories/1").to route_to("company_categories#update", id: "1")
    end
  end
end
