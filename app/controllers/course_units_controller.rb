class CourseUnitsController < ApplicationController
  before_action :set_course_unit, only: %i[ show edit update destroy ]

  # GET /course_units or /course_units.json
  def index
    @course_units = CourseUnit.all
  end

  # GET /course_units/1 or /course_units/1.json
  def show
  end

  # GET /course_units/new
  def new
    @course_unit = CourseUnit.new
  end

  # GET /course_units/1/edit
  def edit
  end

  # POST /course_units or /course_units.json
  def create
    @course_unit = CourseUnit.new(course_unit_params)

    respond_to do |format|
      if @course_unit.save
        format.html { redirect_to @course_unit, notice: "Course unit was successfully created." }
        format.json { render :show, status: :created, location: @course_unit }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course_unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /course_units/1 or /course_units/1.json
  def update
    respond_to do |format|
      if @course_unit.update(course_unit_params)
        format.html { redirect_to @course_unit, notice: "Course unit was successfully updated." }
        format.json { render :show, status: :ok, location: @course_unit }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course_unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /course_units/1 or /course_units/1.json
  def destroy
    @course_unit.destroy!

    respond_to do |format|
      format.html { redirect_to course_units_path, status: :see_other, notice: "Course unit was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def people_registered
    @course_people = CoursePerson.where(course_unit: params[:course_unit_id])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course_unit
      @course_unit = CourseUnit.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def course_unit_params
      params.expect(course_unit: [ :course_id, :unit_id, :instructor_id, :shift, :day, :start_hour, :end_hour, :date, :shift_time, :list ])
    end
end
