import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="forms--certificates"
export default class extends Controller {
  static targets = [ "courseType", "courses", "peopleInCourse", "company", "course" ]
  connect() {
  }

  get_courses() {
    this.coursesTarget.src = `/certificates/courses_by_type?course_type_id=${this.courseTypeTarget.value}`;
  }

  get_people_in_course() {
    this.peopleInCourseTarget.src = `/certificates/get_people_in_course?course_id=${this.courseTarget.value}&operator_id=${this.companyTarget.value}`;
  }
}
