require "rails_helper"

RSpec.describe SectionalsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/sectionals").to route_to("sectionals#index")
    end

    it "routes to #new" do
      expect(get: "/sectionals/new").to route_to("sectionals#new")
    end

    it "routes to #show" do
      expect(get: "/sectionals/1").to route_to("sectionals#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/sectionals/1/edit").to route_to("sectionals#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/sectionals").to route_to("sectionals#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/sectionals/1").to route_to("sectionals#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/sectionals/1").to route_to("sectionals#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/sectionals/1").to route_to("sectionals#destroy", id: "1")
    end
  end
end
