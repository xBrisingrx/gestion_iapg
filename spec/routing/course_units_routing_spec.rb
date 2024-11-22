require "rails_helper"

RSpec.describe CourseUnitsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/course_units").to route_to("course_units#index")
    end

    it "routes to #new" do
      expect(get: "/course_units/new").to route_to("course_units#new")
    end

    it "routes to #show" do
      expect(get: "/course_units/1").to route_to("course_units#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/course_units/1/edit").to route_to("course_units#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/course_units").to route_to("course_units#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/course_units/1").to route_to("course_units#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/course_units/1").to route_to("course_units#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/course_units/1").to route_to("course_units#destroy", id: "1")
    end
  end
end
