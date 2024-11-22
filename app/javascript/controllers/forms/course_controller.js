import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select"

let room_select

// Connects to data-controller="foms--course"
export default class extends Controller {
  static targets = [ "form","courseType", "startHour", "endHour", "courseUnits" ]
  connect() {
    // meti el tomselect aca para poder tener el select en una variable y poder setear el valor 
    room_select = new TomSelect( document.getElementById('course_room_id'), {
      render: {
        no_results:function(data,escape){
          return '<div class="no-results">No hay resultados para "'+escape(data.input)+'"</div>';
        }
      }
    } )
  }
  
  select_default_room() {
    const room_id = this.courseTypeTarget.selectedOptions[0].dataset.room
    room_select.setValue(room_id)
    this.get_yearly_and_general_number()
    // this.add_units_to_form()
    this.get_units()
  }

  get_yearly_and_general_number() {
    if (this.courseTypeTarget.value === "") {
      return
    }
    const course_type_id = this.courseTypeTarget.value
    const url = `/course_types/${course_type_id}/get_yearly_and_general_number`
    fetch(url)
      .then(response => response.json())
      .then(data => {
        document.getElementById('course_year_number').value = data.yearly + 1
        document.getElementById('course_general_number').value = data.general + 1
      })
  }

  get_units() {
    this.courseUnitsTarget.src = `/course_types/${this.courseTypeTarget.value}/course_type_units/add_units_to_form`;
  }
}
