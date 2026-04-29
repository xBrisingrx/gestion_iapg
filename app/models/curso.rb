class Curso < ApplicationRecord
  # Manually specify the table name

  self.table_name = "z_cursos"

  def self.crear_cursos
    ActiveRecord::Base.transaction do
      idsalas = [ 2, 3, 6, 12 ]
      Curso.where(idsala: idsalas).update_all(idsala: 1)
      CupoEmpresa.where(tipocupo: "L").update_all(tipocupo: "Liviana")
      CupoEmpresa.where(tipocupo: "P").update_all(tipocupo: "Pesada")
      course_type = CourseType.find 27
      cursos = Curso.where(idtipocurso: course_type.id)
      course_type_units = CourseTypeUnit.where(course_type: course_type)
      debugger
      cursos.each do |curso|
        company = (curso.cuitempresa != "") ? Company.find_by(cuit: curso.cuitempresa) : nil
        company_id = (company.blank?) ? 5 : company.id
        course = Course.new(
          id: curso.idcurso,
          course_type_id: curso.idtipocurso,
          company_id: company_id,
          room_id: curso.idsala,
          is_company: curso.esincompany,
          from_date: curso.fechadesde,
          to_date: curso.fechahasta,
          code: curso.code,
          year_number: curso.nroanual,
          general_number: curso.nrogeneral,
          years_of_duration: 2
        )
        if course.valid?
          course.save
        else
          debugger
        end
        course_type_units.each do |entry|
          course_unit = CourseUnit.new(
            course_id: course.id,
            unit_id: entry.unit_id,
            shift: entry.shift,
            day: entry.day,
            start_hour: entry.start_hour,
            end_hour: entry.end_hour,
            shift_time: entry.shift_time,
            list: 1
          )
          if course_unit.valid?
            course_unit.save
          else
            debugger
          end
        end # crear curso unidad
      end # crear cursos
    end # transaction
  end # metodo crear_cursos

  def self.registrar_personas
    personas_eliminadas = 0
    ActiveRecord::Base.transaction do
      courses = Course.where(course_type_id: [1,27])
      courses.each do |course|
        personas_en_curso = CupoEmpresa.where(idcurso: course.id)
        unidades_curso = CourseUnit.where(course: course).group(:unit_id)
        personas_en_curso.each do |persona_a_registrar|
          next if persona_a_registrar.tipocupo == "X"
          next if persona_a_registrar.tipocupo == ""
          next if persona_a_registrar.categoriaflota == 0
          if Person.find_by(id: persona_a_registrar.idpersona).blank?
            personas_eliminadas = personas_eliminadas + 1
            next
          end
          fleet_category = FleetCategory.find_by(id: persona_a_registrar.categoriaflota)
          referente = CompanyManager.find_by(id: persona_a_registrar.idreferente)
          company = Company.find_by(id: persona_a_registrar.idempresa)
          data = {
            idcupoempresa: persona_a_registrar.idcupoempresa,
            course_id: course.id,
            person_id: persona_a_registrar.idpersona,
            manager_id: (referente.blank?) ? company.company_managers&.first&.person_id : referente.person_id,
            company_id: company.id,
            operator_id: persona_a_registrar.paraoperadora,
            inscription_motive_id: (persona_a_registrar.subcategoriamotivo == 0) ? 9 : persona_a_registrar.subcategoriamotivo,
            fleet_category_id: fleet_category.id,
            code: course.code,
            expiration_date: persona_a_registrar.fechacancelacion,
            quota_type: :company,
            cancellation_date: persona_a_registrar.fechacancelacion,
            created_at: persona_a_registrar.fechasolicitud,
            canceled: !persona_a_registrar.fechacancelacion.blank?
          }

          # aca tenemos las notas de la persona .. depende que notas tiene cargadas sabemos que modulos hizo
          examen_empresa = ExamenesEmpresa.where(idcupoempresa: persona_a_registrar.idcupoempresa)
          examen_empresa.each do |examen_empresa|
            unidades_curso.each do |course_unit|
              next if course_unit.unit.category == "Practico" && persona_a_registrar.tipocupo != course_unit.unit.fleet
              course_person = CoursePerson.new(data)
              # course_person = CoursePerson.where(
              #                                 idcupoempresa: persona_a_registrar.idcupoempresa,
              #                                 course_id: course.id,
              #                                 person_id: persona_a_registrar.idpersona,
              #                                 unit_id: course_unit.unit_id,
              #                                 course_unit_id: course_unit.id).first
              course_person.unit_id = course_unit.unit_id
              course_person.course_unit_id = course_unit.id
              course_person.date = course_unit.date
              if course_unit.unit.category == "Teorico" && !examen_empresa.notaexamenteorico.blank?
                course_person.scoring = examen_empresa.notaexamenteorico
                course_person.make_up_1 = examen_empresa.notarecuperatorio1
                course_person.date_make_up_1 = examen_empresa.notarecuperatorio1fecha
                course_person.make_up_2 = examen_empresa.notarecuperatorio2
                course_person.date_make_up_2 = examen_empresa.notarecuperatorio2fecha
                course_person.approved = examen_empresa.resultadoteorico
              end
              if course_unit.unit.category == "Practico" && !examen_empresa.notapractico.blank? && persona_a_registrar.tipocupo == course_unit.unit.fleet
                # puede pasar que un curso tenga practica de livianos y pesados, por eso se chequea
                course_person.scoring = examen_empresa.notapractico
                course_person.make_up_1 = examen_empresa.notapracticorecup1
                course_person.make_up_2 = examen_empresa.notapracticorecup2
                course_person.approved = examen_empresa.resultadopractico
              end
              if course_unit.unit.category == "Psicometrico" && !examen_empresa.notapsico.blank?
                course_person.scoring = examen_empresa.notapsico
                course_person.approved = examen_empresa.resultadopsico
              end
              if course_person.valid? && !course_person.scoring.blank?
                course_person.save
              else
                if !course_person.canceled
                  puts course_unit.unit.category
                  debugger
                end
              end
              # debugger if persona_a_registrar.idpersona == 1198
            end # each unidades_curso
          end # each examen_empresa
        end # each personas_en_curso
      end # each courses
    end # transaction
    puts "\n\n\n #{personas_eliminadas} \n\n\n"
  end # registrar_personas
end