import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="forms--course-type-unit"
export default class extends Controller {
  static targets = ["isByTurn","shiftTime"]
  connect() {
    this.is_by_turn()
  }

  is_by_turn() {
    this.shiftTimeTarget.required = this.isByTurnTarget.checked
  }

}
