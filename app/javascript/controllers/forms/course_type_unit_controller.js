import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="forms--course-type-unit"
export default class extends Controller {
  static targets = ["isByTurn","shiftTime", "daysOfDuration"]
  connect() {
    this.is_by_turn()
  }

  is_by_turn() {
    this.shiftTimeTarget.required = this.isByTurnTarget.checked
  }

  need_set_duration(event) {
    const no_teoric = event.target.selectedOptions[0].dataset.category !== "Teorico"
    this.daysOfDurationTarget.classList.toggle("d-none", no_teoric)
  }

  add_instructor(){
    console.info('click')
  }

}
