require "rails_helper"

RSpec.describe CoursePeopleController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/course_people").to route_to("course_people#index")
    end

    it "routes to #new" do
      expect(get: "/course_people/new").to route_to("course_people#new")
    end

    it "routes to #show" do
      expect(get: "/course_people/1").to route_to("course_people#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/course_people/1/edit").to route_to("course_people#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/course_people").to route_to("course_people#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/course_people/1").to route_to("course_people#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/course_people/1").to route_to("course_people#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/course_people/1").to route_to("course_people#destroy", id: "1")
    end
  end
end
