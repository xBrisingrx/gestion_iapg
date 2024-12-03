import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="forms--register-attendance"
export default class extends Controller {
  static targets = ["courseUnit", "form", "tablePeopleRegistered", "courseId"]
  connect() {
  }

  people_registered(){
    this.tablePeopleRegisteredTarget.src = `/courses/${this.courseIdTarget.value}/course_units/${this.courseUnitTarget.value}/people_registered`
  }

  update_attendance() {
    this.formTarget.requestSubmit()
  }
}
