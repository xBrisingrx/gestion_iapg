import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select"
// Connects to data-controller="tselect"
export default class extends Controller {
  // ids son los valores ya seleccionados en ese selector
  // lo uso para recuperar los valores seleccionados cuando vamos a editar
  static values = {
    ids: Array
  }

  connect() {
    new TomSelect( this.element, {
      render: {
        no_results:function(data,escape){
          return '<div class="no-results">No hay resultados para "'+escape(data.input)+'"</div>';
        }
      }
    } ).setValue(this.idsValue)
  }
}
