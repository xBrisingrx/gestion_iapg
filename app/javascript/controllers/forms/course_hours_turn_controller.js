import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="forms--course-hours-turn"
export default class extends Controller {
  update_hour(){
    console.log("click")
  }
}
