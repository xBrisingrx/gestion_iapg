class AsistenciaPdf < Prawn::Document
  def initialize(curso, asistentes)
    super(page_size: "A4", margin: 40)

    @curso = curso
    @asistentes = asistentes

    # repeat(:all) do
    #   canvas do
    #     header
    #     footer
    #   end
    # end

    # move_down 140
    table_content
  end

  # -------------------
  # ENCABEZADO
  # -------------------
  def header
    bounding_box([ 0, bounds.top ], width: bounds.width, height: 120) do
      text "Asistencia de Cursistas", size: 14, style: :bold
      move_down 5
      text "Escuela de Conducción Defensiva"
      text "IAPG Instituto Argentino del Petróleo y del Gas"
      move_down 5

      text "PO -R 08PE"
      text "01/02/2014"
      text "Rev.: 02"

      move_down 5
      text "Sede: #{@curso.room.headquarter.name}   Curso: #{@curso.code}   Sala: #{@curso.room.name}"
      text "Fecha emisión: #{Date.today.strftime('%d/%m/%Y')}    Instructor/es: "

      stroke_horizontal_rule
    end
  end

  # -------------------
  # TABLA
  # -------------------
  def table_content
    table rows, header: true, width: bounds.width do
      row(0).font_style = :bold
      row(0).background_color = "DDDDDD"
      cells.size = 8
      cells.padding = 3
      self.row_colors = [ "FFFFFF", "F2F2F2" ]

      columns(0).width = 30   # Nro
      columns(1).width = 80   # Nombre
      columns(2).width = 80   # Apellido
      columns(3).width = 80   # CUIL
      columns(4).width = 120  # Empresa
      columns(5).width = 80   # Teórico
      columns(6).width = 100  # Motivo
      columns(7).width = 60   # Categoría
      columns(8).width = 50   # Turno
      columns(9).width = 60   # Firma
      columns(10).width = 40  # Nota
    end

    move_down 10
    text "Personas presentes #{@asistentes.count}", size: 9
    text "Ausentes 0", size: 9
  end

  def rows
    [ [ "Nro", "Nombre", "CUIL", "Empresa", "Teórico", "Motivo", "Categoría", "Turno", "Firma", "Nota" ] ] +
      @asistentes.each_with_index.map do |a, i|
        [
          i + 1,
          a.person.fullname,
          a.person.cuil,
          a.company.name,
          a.las_theoric_data,
          a.inscription_motive.name,
          a.fleet_category.name,
          a.from_hour&.strftime("%H:%M"),
          "",
          ""
        ]
      end
  end

  # -------------------
  # PIE DE PÁGINA
  # -------------------
  def footer
    number_pages "Página <page> de <total>",
                 at: [ bounds.right - 120, 0 ],
                 align: :right,
                 size: 8
  end
end
