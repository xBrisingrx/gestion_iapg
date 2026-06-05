import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="forms--course-person"
export default class extends Controller {
  static targets = ["company","selectManagers"]
  connect() {
  }

  get_managers() {
    this.selectManagersTarget.src = `/companies/${this.companyTarget.value}/company_managers/get_to_select`
  }

  check_person_on_other_course(event){
    fetch(`/check_person_on_other_course?person_id=${event.target.value}`)
    .then(response => response.json())
    .then(response => {
      const message = document.getElementsByClassName("text-warning")
      if (response.pending) {
        message[0].innerText = response.message
      } else {
        message[0].innerText = ""
      }
    })
  }
}
