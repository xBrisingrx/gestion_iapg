require 'rails_helper'

RSpec.describe "ElearingExams", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/elearing_exams/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/elearing_exams/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/elearing_exams/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/elearing_exams/update"
      expect(response).to have_http_status(:success)
    end
  end

end
