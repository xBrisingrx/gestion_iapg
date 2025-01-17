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

  remove_unit(event) {
    event.target.parentElement.parentElement.parentElement.remove()
  }

  calc_quota(event) {
    setTimeout(() => {
      const row = event.target.parentElement.parentElement.parentElement
      const shift_time = event.target.dataset.shiftTime
      const row_index = event.target.dataset.index
      const start_hour = row.querySelector(`#course_course_units_start_hour_${row_index}`).value
      const end_hour = row.querySelector(`#course_course_units_end_hour_${row_index}`).value
      const quota = row.querySelector("#calc_quota")
      // Calcula los minutos de cada hora
      var minutos_inicio = start_hour.split(':')
      .reduce((p, c) => parseInt(p) * 60 + parseInt(c));
      var minutos_final = end_hour.split(':')
        .reduce((p, c) => parseInt(p) * 60 + parseInt(c));
      quota.value = Math.round((minutos_final - minutos_inicio) / shift_time)
    }, 1000) 
  }

  validate_instructor(event){
    const row = event.target.parentElement.parentElement.parentElement
    const start_hour = row.querySelector(`.start_hour`).value
    const end_hour = row.querySelector(`.end_hour`).value
    const date = document.querySelector("#course_from_date").value
    fetch(`/instructors/${event.target.value}/is_available?date=${date}&start_hour=${start_hour}&end_hour=${end_hour}`)
      .then(response => response.json())
      .then(response => {
        if(response.instructor_is_available === true){
          event.target.parentElement.querySelector('.text-danger').textContent = ""
        } else {
          event.target.parentElement.querySelector('.text-danger').textContent = "No disponible"
        }
      })
  }

  submit_form(event){
    event.preventDefault()
    const form_data = new FormData(this.formTarget)
    fetch(this.formTarget.action, {
      method: "POST",
      headers:  {
        'Accept': 'application/json',
        'X-CSRF-Token': document.querySelector("meta[name='csrf-token']").getAttribute('content'),
      },
      body: form_data
    })
    .then(response => {
      if(response.status === 201) {
        window.location.replace(response.url)
      } else {
        return response.json()
      }
    })
    .then(response => {
      document.querySelectorAll('.is-invalid').forEach( element => element.classList.remove('is-invalid') )
      document.querySelectorAll('.text-danger').forEach( element => element.innerHTML = '' )
      const response_keys = Object.keys(response)
      for (let i = 0; i < response_keys.length; i++) {
        const message = response[response_keys[i]][0] 
        let input_class = 'course'
        response_keys[i].split('.').forEach(element => {
          input_class += `_${element}`
        })
        document.querySelector(`#${input_class}`).classList.add('is-invalid')
        document.querySelector(`.${input_class}`).innerHTML = message
      }
    })
  }
}
