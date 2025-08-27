class CourseHoursTurnsController < ApplicationController
  def index
    @hours_turns = CourseHoursTurn.where(course_type_unit: params[:course_type_unit])
  end

  def update
    course_hours_turn = CourseHoursTurn.find(params[:id])
    if course_hours_turn.update(course_hours_turn_params)
      render turbo_stream: [
        turbo_stream.replace("toasts",
          partial: "shared/toasts",
          locals: { message: "Hora actualizada.", status_class: "primary" }) ],
        status: :unprocessable_entity
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_course_hours_turn
    @course_hours_turn = CourseHoursTurn.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def course_hours_turn_params
    params.expect(course_hours_turn: [ :hour ])
  end
end
