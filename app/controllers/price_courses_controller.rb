class PriceCoursesController < ApplicationController
  before_action :set_price_course, only: %i[ show edit update destroy ]

  # GET /price_courses or /price_courses.json
  def index
    filter = PriceCourse.filter(params[:query])
    @pagy, @prices = pagy(filter)
    last_price = PriceCourse.last
    @start_date = (last_price.blank?) ? "" : last_price.start_date
    @end_date = (last_price.blank?) ? "" : last_price.end_date
    authorize @prices
  end

  # GET /price_courses/1 or /price_courses/1.json
  def show
  end

  # GET /price_courses/new
  def new
    @price_course = PriceCourse.new
    @course_types = CourseType.actives.order(:name)
  end

  # GET /price_courses/1/edit
  def edit
  end

  # POST /price_courses or /price_courses.json
  def create
    all_created = true
    ActiveRecord::Base.transaction do
      prices = params[:price_course][:price]
      prices.each do |index, price|
        puts "#{index} => #{price}"
        PriceCourse.create(
          price: price,
          course_type_id: params[:price_course][:course_type_id][index.to_s],
          start_date: params[:price_course][:start_date]
        )
      end
    end

    rescue ActiveRecord::RecordInvalid
      all_created = false
    respond_to do |format|
      if all_created
        format.html { redirect_to @price_course, notice: "Price course was successfully created." }
        format.json { render :show, status: :created, location: @price_course }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @price_course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /price_courses/1 or /price_courses/1.json
  def update
    respond_to do |format|
      if @price_course.update(price_course_params)
        format.html { redirect_to @price_course, notice: "Price course was successfully updated." }
        format.json { render :show, status: :ok, location: @price_course }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @price_course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /price_courses/1 or /price_courses/1.json
  def destroy
    @price_course.destroy!

    respond_to do |format|
      format.html { redirect_to price_courses_path, status: :see_other, notice: "Price course was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_price_course
      @price_course = PriceCourse.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def price_course_params
      params.expect(price_course: [ price: [], course_type_id: [], start_date: [], end_date: [] ])
    end
end
