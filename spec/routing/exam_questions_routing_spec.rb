require "rails_helper"

RSpec.describe ExamQuestionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/exam_questions").to route_to("exam_questions#index")
    end

    it "routes to #new" do
      expect(get: "/exam_questions/new").to route_to("exam_questions#new")
    end

    it "routes to #show" do
      expect(get: "/exam_questions/1").to route_to("exam_questions#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/exam_questions/1/edit").to route_to("exam_questions#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/exam_questions").to route_to("exam_questions#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/exam_questions/1").to route_to("exam_questions#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/exam_questions/1").to route_to("exam_questions#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/exam_questions/1").to route_to("exam_questions#destroy", id: "1")
    end
  end
end
