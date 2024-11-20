import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="forms--person"
export default class extends Controller {
  static targets = ["cuil"]

  connect() {
  }

  check_cuil() {
    if( this.cuilTarget.parentElement.querySelector(".invalid-feedback") !== null ) {
      this.cuilTarget.parentElement.querySelector(".invalid-feedback").remove()
    }
    this.cuilTarget.classList.toggle("is-invalid", !this.cuil_is_valid())
    if(!this.cuil_is_valid()) {
      this.cuilTarget.insertAdjacentHTML(
        "afterEnd",
        "<span class='invalid-feedback'>CUIL inválido</span>"
      )
    }
  }

  cuil_is_valid() {
    const cuit = this.cuilTarget.value
    if (cuit.length != 11) return 0;
		
		var rv = false;
		var resultado = 0;
		var cuit_nro = cuit.replace("-", "");
		var codes = "6789456789";
		var verificador = parseInt(cuit_nro[cuit_nro.length-1]);
		var x = 0;
		
		while (x < 10) {
			var digitoValidador = parseInt(codes.substring(x, x+1));
			if (isNaN(digitoValidador)) digitoValidador = 0;
			var digito = parseInt(cuit_nro.substring(x, x+1));
			if (isNaN(digito)) digito = 0;
			var digitoValidacion = digitoValidador * digito;
			resultado += digitoValidacion;
			x++;
		}
		resultado = resultado % 11;
		rv = (resultado == verificador);
		return rv;
  }
}
