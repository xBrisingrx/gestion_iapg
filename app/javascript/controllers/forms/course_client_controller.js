import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="forms--course-client"
export default class extends Controller {
  static targets = ["form", "cuil", "personName", "personId", "filterCourses", "selectTeorico"]
  connect() {
    console.info('cliente')
  }

  get_person_by_cuil() {
    if (this.cuilTarget.value.length >= 7 ) {
      fetch(`/people/by_cuil?cuil=${this.cuilTarget.value}`)
      .then(response => response.json())
      .then(data => {
        const error = document.querySelector('.person_name')
        if(data.name != '') {
          this.personNameTarget.value = data.name
          this.personIdTarget.value = data.id
          error.innerHTML = ""
          document.querySelector('input[type="submit"]').disabled = false
        } else {
          error.innerHTML = "Esta persona no esta registrada"
          document.querySelector('input[type="submit"]').disabled = true
        }
      })
    }
  }

  select_teoricos() {
    const option_selected = this.filterCoursesTarget.selectedOptions[0]
    const course_category = option_selected.dataset.category
    if(this.filterCoursesTarget.value != ""){
      this.selectTeoricoTarget.src = `/courses/get_teoricos_by_category?course_category=${course_category}`
    }
  }

  register(event) {
    // event.preventDefault()
    // event.stopPropagation()
    
  }
}
