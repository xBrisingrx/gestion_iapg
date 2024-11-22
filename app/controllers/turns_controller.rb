class TurnsController < ApplicationController
  def index;end

  def update
    turn = Turn.find(params[:id])

    if turn.update(turn_params)
      render turbo_stream: [
        turbo_stream.replace("toasts",
          partial: "shared/toasts",
          locals: { message: "Estado actualizado", status_class: "primary" })
      ]
    else
      render turbo_stream: [
        turbo_stream.replace("toasts",
          partial: "shared/toasts",
          locals: { message: "Error", status_class: "danger" })
      ]
    end
  end

  private
  def turn_params
    params.require(:turn).permit(:status)
  end
end
