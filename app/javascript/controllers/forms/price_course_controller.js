import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="forms--price-course"
export default class extends Controller {
  connect() {
    console.info("precios")
  }
}
