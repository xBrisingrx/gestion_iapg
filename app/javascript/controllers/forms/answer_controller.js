import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="forms--answer"
export default class extends Controller {
  static targets = ["form"]
  update_answer(event) {
    // solo actualizamos si es correcta o no
    this.formTarget.requestSubmit()
  }
}
