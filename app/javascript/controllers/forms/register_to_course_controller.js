import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="forms--register-to-course"
export default class extends Controller {
  static targets = ["form", "filterCourses", "selectTeorico", "selectPractico", "selectPsicometrico", "courseTeorico","coursePractico","coursePsicometrico"]
  connect() {
  }

  select_teoricos() {
    const option_selected = this.filterCoursesTarget.selectedOptions[0]
    const course_category = option_selected.dataset.category
    // const fleet = option_selected.dataset.fleet
    if(this.filterCoursesTarget.value != ""){
      this.selectTeoricoTarget.src = `/courses/get_teoricos_by_category?course_category=${course_category}`
    }
  }

  select_teoricos_in_company() {
    const option_selected = this.filterCoursesTarget.selectedOptions[0]
    const course_category = option_selected.dataset.category
    const company_id = document.querySelector("#company_id").value 
    // const fleet = option_selected.dataset.fleet
    if(this.filterCoursesTarget.value != ""){
      this.selectTeoricoTarget.src = `/courses/get_teoricos_in_company?course_category=${course_category}&company_id=${company_id}`
    }
  }

  select_practicos() {
    const option_course_selected = this.filterCoursesTarget.selectedOptions[0]
    const course_category = option_course_selected.dataset.category // categoria seleccionada [inicio/renovacion]
    const fleet = option_course_selected.dataset.fleet // flota seleccionada [liviano/pesado]
    const option_selected = this.courseTeoricoTarget.selectedOptions[0]
    const date = option_selected.dataset.date
    const course_id = option_selected.dataset.course
    if(course_id != ""){
      this.selectPracticoTarget.src = `/courses/get_cursos_practicos?&course_category=${course_category}&fleet=${fleet}&date=${date}&course_id=${course_id}`
      this.selectPsicometricoTarget.src = `/courses/get_psicometricos?&date=${date}&course_id=${course_id}`
      document.querySelector("#course_date_teorico").value = date
    }

    setTimeout(() => {
      if( document.querySelector("#practico_id") != null ) {
        document.querySelector("#course_date_practico").value = document.querySelector("#practico_id").selectedOptions[0].dataset.date
      }
      if( document.querySelector("#psicometrico_id") != null ) {
        document.querySelector("#course_date_psicometrico").value = document.querySelector("#psicometrico_id").selectedOptions[0].dataset.date
      }
    }, 2000);
  }

  set_date_practico() {
    const option_selected = this.coursePracticoTarget.selectedOptions[0]
    document.querySelector("#course_date_practico").value = option_selected.dataset.date
  }

  set_date_psicometrico() {
    const option_selected = this.coursePsicometricoTarget.selectedOptions[0]
    document.querySelector("#course_date_psicometrico").value = option_selected.dataset.date
  }
}
