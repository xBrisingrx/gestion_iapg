import { Controller } from "@hotwired/stimulus"
import { Toast } from "bootstrap"
// Connects to data-controller="toast"
export default class extends Controller {
  connect() {
    const liveToast = new Toast(document.querySelector('#liveToast'))
    liveToast.show()
  }
}
