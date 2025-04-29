class Api::ElearningController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate

  def index
    puts params
    iat = Time.new.to_i
    exp = iat * (60 * 60)
    token = jwt_encode({
      iat: iat,
      exp: exp,
      data: {
        id: 1,
        cuil: "20353846303",
        apellido: "Almiron",
        nombre: "Mauro",
        curso: 7,
        examen: "examen",
        cupo: "cupo",
        tipo: "tipo",
        tipocupo: "tipocupo"
      }
    })
    render json: { message: "Successful login.", jwt: token }
  end
end
