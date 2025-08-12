import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="forms--turn"
export default class extends Controller {
  static targets = ["form", "changeTurn"]
  update_turn() {
    this.formTarget.requestSubmit()
  }

  change_turn() {
    console.info("turnitos")
    this.changeTurnTarget.requestSubmit()
  }
}
