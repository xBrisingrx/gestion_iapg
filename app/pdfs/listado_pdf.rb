class ListadoPdf < Prawn::Document
  def initialize(course, course_people)
    super(page_size: "A4", margin: 40)

    @course = course
    @course_people = course_people

    table_content
  end

  def table_content
    font "Helvetica"
    text "Listado personas", align: :center, size: 24
    image Rails.root.join("app/assets/images/logo.png")
    move_down 5
    move_down 12
    table rows, header: true, width: bounds.width do
      row(0).font_style = :bold
      self.row_colors = [ "DDDDDD", "FFFFFF" ]
      self.cell_style = { borders: [ :top, :bottom, :left, :right ], padding: 5 }
    end
  end

  def rows
    [ [ "Nombre y apellido", "Cuil", "Empresa", "Teorico", "Categoria", "Turno", "Firma" ] ] +
                      @course_people.map { |u| [
                        u.person.fullname, u.person.cuil, u.company.name, u.scoring_theoric, u.fleet_category.name, u.from_hour&.strftime("%H:%M"), "  " ] }
  end
end
