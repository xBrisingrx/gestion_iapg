require 'rails_helper'

RSpec.describe "Courses::Practices", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/courses/practices/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/courses/practices/create"
      expect(response).to have_http_status(:success)
    end
  end

end
