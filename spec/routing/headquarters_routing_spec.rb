require "rails_helper"

RSpec.describe HeadquartersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/headquarters").to route_to("headquarters#index")
    end

    it "routes to #new" do
      expect(get: "/headquarters/new").to route_to("headquarters#new")
    end

    it "routes to #show" do
      expect(get: "/headquarters/1").to route_to("headquarters#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/headquarters/1/edit").to route_to("headquarters#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/headquarters").to route_to("headquarters#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/headquarters/1").to route_to("headquarters#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/headquarters/1").to route_to("headquarters#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/headquarters/1").to route_to("headquarters#destroy", id: "1")
    end
  end
end
