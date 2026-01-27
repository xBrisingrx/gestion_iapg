import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="forms--invoice"
export default class extends Controller {
  static targets = ["form", "company", "items", "add"]

  connect() {
    console.log("conectado")
  }

  get_pendings() {
    if(this.companyTarget.value != ""){
      this.itemsTarget.src = `/get_pendings?company_id=${this.companyTarget.value}`
    }
  }

  add_item(event) {
    const items = document.querySelectorAll(".item_price")
    let sumatoria = 0
    for (const item of items) {
      const element = item.parentElement.querySelector(".form-check-input").checked
      if (element) {
        sumatoria += parseInt(item.value)
      }
    }
    document.getElementById("total").innerText = `$${sumatoria}.00`
  }
}
