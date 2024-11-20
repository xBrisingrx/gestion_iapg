require "rails_helper"

RSpec.describe IvaConditionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/iva_conditions").to route_to("iva_conditions#index")
    end

    it "routes to #new" do
      expect(get: "/iva_conditions/new").to route_to("iva_conditions#new")
    end

    it "routes to #show" do
      expect(get: "/iva_conditions/1").to route_to("iva_conditions#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/iva_conditions/1/edit").to route_to("iva_conditions#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/iva_conditions").to route_to("iva_conditions#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/iva_conditions/1").to route_to("iva_conditions#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/iva_conditions/1").to route_to("iva_conditions#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/iva_conditions/1").to route_to("iva_conditions#destroy", id: "1")
    end
  end
end
