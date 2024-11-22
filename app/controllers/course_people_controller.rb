class CoursePeopleController < ApplicationController
  before_action :set_course_person, only: %i[ show edit update destroy ]

  # GET /course_people or /course_people.json
  def index
    @course_people = CoursePerson.all
  end

  # GET /course_people/1 or /course_people/1.json
  def show
  end

  # GET /course_people/new
  def new
    @course_person = CoursePerson.new
  end

  # GET /course_people/1/edit
  def edit
  end

  # POST /course_people or /course_people.json
  def create
    @course_person = CoursePerson.new(course_person_params)

    respond_to do |format|
      if @course_person.save
        format.html { redirect_to @course_person, notice: "Course person was successfully created." }
        format.json { render :show, status: :created, location: @course_person }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course_person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /course_people/1 or /course_people/1.json
  def update
    respond_to do |format|
      if @course_person.update(course_person_params)
        format.html { redirect_to @course_person, notice: "Course person was successfully updated." }
        format.json { render :show, status: :ok, location: @course_person }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course_person.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /course_people/1 or /course_people/1.json
  def destroy
    @course_person.destroy!

    respond_to do |format|
      format.html { redirect_to course_people_path, status: :see_other, notice: "Course person was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course_person
      @course_person = CoursePerson.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def course_person_params
      params.expect(course_person: [ :course_id, :person_id, :company_id, :inscription_motive_id, :fleet_category_id, :unit_id, :course_unit_id, :date, :from_hour, :to_hour, :active ])
    end
end
