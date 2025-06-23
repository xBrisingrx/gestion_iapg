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

  need_set_duration(event) {
    const unit_category = console.info(event.target.selectedOptions[0].dataset.category)
    if(unit_category) {
      
    }
  }

}
