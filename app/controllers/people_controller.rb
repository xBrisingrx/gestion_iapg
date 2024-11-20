class PeopleController < ApplicationController
  before_action :set_person, only: %i[ show edit update modal_disable disable ]

  # GET /people or /people.json
  def index
    @query = Person.actives.ransack(params[:query])
    @pagy, @people = pagy(@query.result)
    authorize @people
  end

  # GET /people/1 or /people/1.json
  def show;end

  # GET /people/new
  def new
    @person = Person.new
    authorize @person
  end

  # GET /people/1/edit
  def edit;end

  # POST /people or /people.json
  def create
    @person = Person.new(person_params)
    respond_to do |format|
      if @person.save
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.prepend("tbody_people",
              partial: "people/person",
              locals: { person: @person }),
              turbo_stream.replace("toasts",
                partial: "shared/toasts",
                locals: { message: "Persona registrada con éxito.", status_class: "primary" })
          ]
        }
        format.html { redirect_to person_url(@person), notice: "Persona registrada con éxito." }
        format.json { render :show, status: :created, location: @person }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /people/1 or /people/1.json
  def update
    respond_to do |format|
      if @person.update(person_params)
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.replace(@person,
              partial: "people/person",
              locals: { person: @person }),
              turbo_stream.replace("toasts",
                partial: "shared/toasts",
                locals: { message: "Datos actualizados.", status_class: "primary" })
          ]
        }
        format.html { redirect_to person_url(@person), notice: "Datos actualizados." }
        format.json { render :show, status: :ok, location: @person }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  def modal_disable;end

  def disable
    if @person.disable
        render turbo_stream: [
          turbo_stream.remove(@person),
          turbo_stream.replace("toasts",
            partial: "shared/toasts",
            locals: { message: "Persona dada de baja.", status_class: "primary" })
        ], status: :ok
    else
      render turbo_stream: [
        turbo_stream.replace("toasts",
          partial: "shared/toasts",
          locals: { message: "No se pudo dar de baja a la persona.", status_class: "danger" }) ],
        status: :unprocessable_entity
    end
  end

  def search
    person = Person.select(:id, :name, :last_name).where("cuil LIKE ?", "%#{params[:query]}%").first
    render json: { person: person }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params.expect(:id))
      authorize @person
    end

    # Only allow a list of trusted parameters through.
    def person_params
      params.expect(person: [ :cuil, :last_name, :name, :birthdate, :phone, :celphone, :email, :direction, :code, :city_id ])
    end
end
