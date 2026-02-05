import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="forms--invoice"
export default class extends Controller {
  static targets = ["form", "company", "items", "add", "bonus"]

  connect() {
  }

  get_pendings() {
    if(this.companyTarget.value != ""){
      this.itemsTarget.src = `/get_pendings?company_id=${this.companyTarget.value}`
    }
  }

  add_item() {
    this.calculate_total()
  }

  set_bonus(event) {
    const row = event.target.parentElement.parentElement.parentElement
    this.change_amount_text(row, event.target.checked)
    this.calculate_total()
  }

  calculate_total() {
    const items = document.querySelectorAll(".item_price")
    let sumatoria = 0
    for (const item of items) {
      const add_item = item.parentElement.querySelector("#add_item").checked
      const is_free = item.parentElement.querySelector("#bonus").checked
      if (add_item && !is_free) {
        sumatoria += parseInt(item.value)
      }
    }
    document.getElementById("total").innerText = `$${sumatoria}.00`
  }
  
  submit(event) {
    event.preventDefault()
    let form = new FormData()
    form.append(`invoice[date]`, document.getElementById("invoice_date").value)
    form.append(`invoice[company_id]`, document.getElementById("invoice_company_id").value)
    const course_people = document.querySelectorAll(".course_person")
    for (let i = 0; i < course_people.length; i++) {
      if (course_people[i].querySelector(".form-check-input").checked) {
        const course_person_id = course_people[i].querySelector("#course_person_id").value
        const set_free = course_people[i].querySelector("#bonus").checked
        form.append(`invoice[invoice_items_attributes][${i}][course_person_id]`, course_person_id)
        if (set_free) {
          form.append(`invoice[invoice_items_attributes][${i}][set_free]`, set_free)
        }
      }
    }
    fetch("/invoices", {
      method: "POST",
      headers: {           
        'X-CSRF-Token': document.getElementsByName('csrf-token')[0].content,
      },
      body: form
    })
    .then( response => response.json() )
    .then( data => window.location.reload() )
    .catch( error => console.error('error', 'Ocurrio un error') )
  }

  set_is_free(event) {
    const row = event.target.parentElement.parentElement.parentElement
    this.change_amount_text(row, event.target.checked)
    row.querySelector(".invoice_item_set_free").value = event.target.checked
    const items = document.querySelectorAll(".item_price")
    let sumatoria = 0
    for (const item of items) {
      const is_free = item.parentElement.querySelector(".bonus").checked
      if (!is_free) {
        sumatoria += parseInt(item.value)
      }
    }
    document.getElementById("total").innerText = `$${sumatoria}.00`
  }

  change_amount_text(row, is_free) {
    if (is_free) {
      row.querySelector(".price").innerHTML = "<span class='badge bg-info'>Bonificado</span>"
    } else {
      const item_price = row.querySelector("#course_person_price").value
      row.querySelector(".price").innerHTML = `$${item_price}.00`
    }
  }
}
