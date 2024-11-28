import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="forms--course-person"
export default class extends Controller {
  static targets = ["company","selectManagers"]
  connect() {
    console.log('connect')
  }

  get_managers() {
    console.log('get')
    this.selectManagersTarget.src = `/companies/${this.companyTarget.value}/managers/get_to_select`
  }
}
