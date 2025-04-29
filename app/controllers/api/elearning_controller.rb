class Api::ElearningController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate

  def index
    puts params

    token = jwt_encode([
      data: [
        id: 1,
        cuil: "20353846303",
        apellido: "Almiron",
        nombre: "Mauro",
        curso: 7,
        examen: "examen",
        cupo: "cupo",
        tipo: "tipo",
        tipocupo: "tipocupo"
      ]
    ])
    render json: [ message: "Successful login.", jwt: token ]
  end
end
