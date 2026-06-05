class HistorialPersonaPdf < RBPDF
  def initialize(persona:, courses:)
    super("L", "mm", "A4", true, "UTF-8", false)

    @persona = persona
    @courses = courses

    self.SetMargins(10, 50, 10)
    self.SetAutoPageBreak(true, 10)
    self.SetFont("helvetica", "", 10)

    self.AddPage

    contenido
  end

  # =========================
  # 🧱 HEADER (CLASE TCPDF → RBPDF)
  # =========================
  def Header
    image_file = Rails.root.join("app/assets/images/banner_iapg.jpg")

    self.Image(image_file.to_s, 14, 11, 25)

    self.SetFont("helvetica", "B", 10)

    self.SetXY(10, 7)

    # cajas superiores
    self.Cell(33, 27, "", 1)
    self.Cell(210, 27, "", 1)
    self.Cell(33, 27, "", 1, 1)

    self.Cell(276, 5, "Reporte Historial de Persona", 1, 1, "C")

    self.SetFont("helvetica", "B", 14)
    self.SetXY(0, 16)
    self.Cell(0, 0, "Escuela de Conducción Defensiva", 0, 1, "C")

    self.SetFont("helvetica", "", 12)
    self.SetXY(0, 22)
    self.Cell(0, 0, "IAPG Instituto Argentino del Petróleo y del Gas", 0, 1, "C")

    self.SetFont("helvetica", "", 10)
    self.SetXY(250, 16)
    self.Cell(0, 0, "Fecha emision", 0, 1, "C")

    self.SetXY(250, 22)
    self.Cell(0, 0, Date.today.strftime("%d/%m/%Y"), 0, 1, "C")
  end

  # =========================
  # 📄 FOOTER
  # =========================
  def Footer
    self.SetY(-15)
    self.SetFont("helvetica", "I", 8)

    texto = "Página #{self.getAliasNumPage} de #{self.getAliasNbPages}"
    self.Cell(0, 0, texto, 0, 0, "R")
  end

  # =========================
  # 👤 CONTENIDO
  # =========================
  def contenido
    self.SetXY(10, 43)
    image_file = (@persona.images.attached?) ? ActiveStorage::Blob.service.path_for(@persona.images.last.key) : Rails.root.join("app/assets/images/credencial/faces/example.jpg")

    self.Image(image_file.to_s, 10, 43, 40)
    html = <<~HTML
      <table width="100%" style="font-size:10pt;">
        <tr>
          <td width="15%">
          </td>
          <td width="85%">
            <table width="100%">
              <tr>
                <td>Apellido y Nombre: #{@persona.fullname}</td>
                <td>Localidad: #{@persona.city.name}</td>
              </tr>
              <tr>
                <td>CUIL: #{@persona.cuil}</td>
                <td>Provincia: #{@persona.province.name}</td>
              </tr>
              <tr>
                <td>Fecha Nacimiento: #{@persona.birthdate}</td>
                <td>Correo Electronico: #{@persona.email}</td>
              </tr>
              <tr>
                <td>Telefono: #{@persona.phone}</td>
                <td>Domicilio: #{@persona.direction}</td>
              </tr>
              <tr>
                <td>Nro.Celular: #{@persona.celphone}</td>
                <td></td>
              </tr>
              <tr>
                <td>Código de validación: #{@persona.code}</td>
                <td></td>
              </tr>
            </table>
          </td>
        </tr>
      </table>

      <br>
      <b>Repositorio Vigente desde Feb/2014</b>
      <br><br>

      #{tabla_historial}
    HTML

    self.writeHTML(html)
  end

  # =========================
  # 📊 TABLA HISTORIAL
  # =========================
  def tabla_historial
    rows = @courses.map do |course|
      courses_person = CoursePerson.where(course: course, person: @persona)
      course_person = courses_person.first
      data = "<tr>
          <td>#{course.from_date.strftime('%d/%m/%Y')}</td>
          <td>#{course_person.company.name}</td>
          <td>#{course.course_type.name}</td>
          <td>#{course.room.headquarter.name}</td>
          <td>#{course_person.fleet_category.name}</td>
          <td>#{course_person.inscription_motive.name}</td>
          <td>#{course_person.nota_pdf_historico("Teorico", "scoring")}</td>
          <td>estado</td>
          <td>#{course_person.nota_pdf_historico("Teorico", "make_up_1")}</td>
          <td>#{course_person.nota_pdf_historico("Teorico", "make_up_2")}</td>
          <td>#{course_person.nota_pdf_historico("Psicometrico", "scoring")}</td>
          <td>#{course_person.nota_pdf_historico("Practico", "scoring")}</td>
          <td></td>
        </tr>"

      if !courses_person.joins(:unit).where(units: { category: "Practico" }).blank?
        practica = courses_person.joins(:unit).where(units: { category: "Practico" }).first
        data = data+"<tr>
          <td>#{course.from_date.strftime('%d/%m/%Y')}</td>
          <td>#{course_person.company.name}</td>
          <td>Practico flota #{practica.unit.fleet}</td>
          <td>#{course.room.headquarter.name}</td>
          <td>#{course_person.fleet_category.name}</td>
          <td>#{course_person.inscription_motive.name}</td>
          <td></td>
          <td>estado</td>
          <td></td>
          <td></td>
          <td>#{course_person.nota_pdf_historico("Psicometrico", "scoring")}</td>
          <td>#{course_person.nota_pdf_historico("Practico", "scoring")}</td>
          <td></td>
        </tr>"
      end
      <<~ROW
        #{data}
      ROW
    end.join

    <<~HTML
      <table border="1" cellpadding="3" width="100%">
        <tr style="background-color:steelblue;color:white;">
          <th>Fecha</th>
          <th>Empresa</th>
          <th>Tipo</th>
          <th>Sede</th>
          <th>Vehículo</th>
          <th>Motivo</th>
          <th>Teorico</th>
          <th>Credencial</th>
          <th>Recup.1</th>
          <th>Recup.2</th>
          <th>Psicom.</th>
          <th>Eval.Prac</th>
          <th>EP Hora</th>
        </tr>
        #{rows}
      </table>
    HTML
  end
end
