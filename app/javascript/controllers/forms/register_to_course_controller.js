import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="forms--register-to-course"
export default class extends Controller {
  static targets = ["form", "filterCourses", "selectTeorico", "selectPractico", "selectPsicometrico", "courseTeorico"]
  connect() {
  }

  select_teoricos() {
    const option_selected = this.filterCoursesTarget.selectedOptions[0]
    const course_category = option_selected.dataset.category
    const fleet = option_selected.dataset.fleet
    if(this.filterCoursesTarget.value != ""){
      this.selectTeoricoTarget.src = `/courses/by_course_category_and_fleet?course_category=${course_category}&fleet=${fleet}`
    }
  }

  select_practicos() {
    const option_teorico_selected = this.filterCoursesTarget.selectedOptions[0]
    const course_category = option_teorico_selected.dataset.category
    const fleet = option_teorico_selected.dataset.fleet

    const option_selected = this.courseTeoricoTarget.selectedOptions[0]
    const date = option_selected.dataset.date
    if(this.courseTeoricoTarget.value != ""){
      this.selectPracticoTarget.src = `/courses/get_cursos_practicos?course_category=${course_category}&fleet=${fleet}&date=${date}`
      this.selectPsicometricoTarget.src = `/courses/get_psicometricos?&date=${date}`
      document.querySelector("#course_date_teorico").value = option_selected.dataset.date
    }
  }

  set_date_practico() {
    const option_selected = this.coursePracticoTarget.selectedOptions[0]
    console.log(option_selected.dataset.date)
    document.querySelector("#course_date_practico").value = option_selected.dataset.date
  }

  set_date_psicometrico() {
    const option_selected = this.coursePsicometricoTarget.selectedOptions[0]
    console.log(option_selected.dataset.date)
    document.querySelector("#course_date_psicometrico").value = option_selected.dataset.date
  }
}
