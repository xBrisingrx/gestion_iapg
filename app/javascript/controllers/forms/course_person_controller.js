import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="forms--course-person"
export default class extends Controller {
  static targets = ["company","selectManagers"]
  connect() {
  }

  get_managers() {
    this.selectManagersTarget.src = `/companies/${this.companyTarget.value}/company_managers/get_to_select`
  }
}
