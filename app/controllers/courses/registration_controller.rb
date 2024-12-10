class Courses::RegistrationController < ApplicationController
  def new
  end

  def create
    debugger
    render json: "bugssssss", status: :unprocessable_entity
  end
end
