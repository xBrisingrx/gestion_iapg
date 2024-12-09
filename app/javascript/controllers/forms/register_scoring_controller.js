import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="forms--register-scoring"
export default class extends Controller {
  static targets = ["selectCourses", "tableCoursePeople", "typeCourse"]
  connect() {
  }

  get_courses(){
    if(this.typeCourseTarget.value != ""){
      this.selectCoursesTarget.src = `/courses/by_course_type?course_type_id=${this.typeCourseTarget.value}`
    }
  }

  draw_course_people_table() {
    const course_id = this.element.querySelector("#select_courses").value 
    this.tableCoursePeopleTarget.src = `/courses/${course_id}/course_people/by_course`
  }
}
