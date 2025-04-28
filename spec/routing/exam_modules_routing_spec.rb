require "rails_helper"

RSpec.describe ExamModulesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/exam_modules").to route_to("exam_modules#index")
    end

    it "routes to #new" do
      expect(get: "/exam_modules/new").to route_to("exam_modules#new")
    end

    it "routes to #show" do
      expect(get: "/exam_modules/1").to route_to("exam_modules#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/exam_modules/1/edit").to route_to("exam_modules#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/exam_modules").to route_to("exam_modules#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/exam_modules/1").to route_to("exam_modules#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/exam_modules/1").to route_to("exam_modules#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/exam_modules/1").to route_to("exam_modules#destroy", id: "1")
    end
  end
end
