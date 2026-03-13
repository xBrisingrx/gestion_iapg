class CoursePerson < ApplicationRecord
  belongs_to :course
  belongs_to :person
  belongs_to :manager, class_name: "Person", optional: true
  belongs_to :company, optional: true
  belongs_to :operator, class_name: "Company", optional: true
  belongs_to :inscription_motive, optional: true
  belongs_to :fleet_category, optional: true
  belongs_to :unit
  belongs_to :course_unit
  has_one :turn
  has_one :course_type, through: :course

  enum :attendance_status, [ :no_registeder, :presence, :absent, :no_documents ]
  enum :quota_type, [ :company, :particular ]
  enum :pay_status, [ :no_pay, :pay, :free, :invoiced ] # free es cuando no corresponde que paguen

  attr_accessor :practical_turn_id, :psicometrico_turn_id

  before_create :set_code
  before_create :set_expiration_date
  # after_update :check_approved
  scope :actives, -> { where(active: true) }

  # validate :check_introductory_course
  # validate :check_renovation_course

  def self.ransackable_attributes(auth_object = nil)
    [ "active", "person_id", "manager_id", "course_id", "operator_id", "created_at", "inscription_motive_id", "fleet_category_id",
      "unit_id", "id", "id_value", "turn_id", "course_unit_id", "updated_at", "company_id", "status", "pay_status" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "person", "unit", "course", "course_unit", "turn", "course_type", "company" ]
  end

  def disable
    course_people = CoursePerson.actives.where(course: self.course, person: self.person)
    ActiveRecord::Base.transaction do
      course_people.each do |course_person|
        course_person.update(active: false)
        turn = Turn.find_by(person: course_person.person, course: course_person.course, course_unit: course_person.course_unit)
        if !turn.blank?
          turn.update(person: nil, status: :available, available: true)
        end
        raise ActiveRecord::Rollback if course_person.has_scoring?
      end
    end
  end

  def has_scoring?
    (self.scoring > 0 || self.make_up_1 > 0 || self.make_up_2 > 0)
  end

  def assign_turn
    # metodo mal hecho porq lo llamamos de una instancia que no guardamos nunca
    # return if self.course.course_type.days == 1 || CoursePerson.where(course_id: self.course_id, person_id: self.person_id).count > 1
    course_units = CourseUnit.where(course_id: self.course_id).group(:unit_id)
    course_date = self.course.from_date
    sectional_id = self.course.room.headquarter.sectional.id
    ActiveRecord::Base.transaction do
      course_units.each do |course_unit|
        next if CoursePerson.find_by(course_id: self.course_id, person_id: self.person_id, unit_id: course_unit.unit_id)
        course_type_unit = CourseTypeUnit.find_by(course_type_id: self.course.course_type_id, unit_id: course_unit.unit_id)
        unit_price = course_unit.unit.get_price(sectional_id, self.company_id)
        course_person = CoursePerson.new(
          course_id: self.course_id,
          person_id: self.person_id,
          manager_id: self.manager_id,
          company_id: self.company_id,
          operator_id: self.operator_id,
          inscription_motive_id: self.inscription_motive_id,
          fleet_category_id: self.fleet_category_id,
          unit_id: course_unit.unit_id,
          course_unit_id: course_unit.id,
          price: unit_price,
          status: "Pendiente"
        )
        course_person.date = course_date + (course_unit.day - 1).day
        if course_type_unit.is_by_turn
          if course_type_unit.unit.category == "Psicometrico"
            turn_id = self.psicometrico_turn_id
          end

          if course_type_unit.unit.category == "Practico"
            turn_id = self.practical_turn_id
          end
          # course_person.from_hour = set_hour(course_unit.unit_id, self.course_id, course_person.date, course_type_unit.shift_time)
          course_person.from_hour = set_turn(turn_id, course_person.date, course_type_unit.shift_time)
          course_person.to_hour = course_person.from_hour + course_type_unit.shift_time.minutes
        end
        course_person.save
        raise ActiveRecord::Rollback if course_person.id.nil?
      end # end course_units.each
    end # end transaction
  end

  def set_turn(turn_id, date, shift_time)
    turn = Turn.find(turn_id)
    if !turn.person_id.blank?
      Turn.create(
        course_id: turn.course_id,
        unit_id: turn.unit_id,
        date: turn.date,
        hour: turn.hour,
        list: turn.list,
        status: :busy,
        available: false,
        person_id: self.person_id
      )
    else
      turn.update(available: false, person_id: self.person_id, status: :busy)
    end
    turn.hour
    # if self.person_is_available(shift_time, date, turn.hour)
    #   turn.update(available: false, person_id: self.person_id, status: :busy)
    #   turn.hour
    # else
    #   errors.add(:psicometrico_turn_id, "Los horarios se superponen.")
    #   errors.add(:practical_turn_id, "Los horarios se superponen.")
    #   raise ActiveRecord::Rollback
    # end
  end

  def set_hour(unit_id, course_id, date, shift_time)
    # seteamos la hora si es que el modulo va por turnos
    # debemos tener en cuenta que no se pise con turnos de otros ni con un turno q tenga esta persona
    # ya que el mismo dia puede tener practica y psicometrico
    turn_available = Turn.where(course_id: course_id, unit_id: unit_id, status: :available).order(:hour)
    turn_hour = nil
    turn_available.each do |turn|
      if self.person_is_available(shift_time, date, turn.hour)
        turn_hour = turn.hour
        turn.update(person_id: self.person_id, status: :busy)
      end
      break if !turn_hour.blank?
    end
    turn_hour
  end

  def person_is_available(shift_time, date, hour)
    # la persona esta disponible en este horario
    end_hour = hour + shift_time.minutes
    cp = CoursePerson
          .where(person_id: self.person_id)
          .where(date: date)
    cp_from_hour = cp.where(from_hour: hour)
    cp_to_hour = cp.where(to_hour: end_hour)
    cp_from_hour.empty? && cp_to_hour.empty?
  end

  def self.by_course(course_id)
    CoursePerson.where(course: course_id)
      .includes(:person, :company)
      .group(:person_id)
      .order(people: { last_name: :asc })
  end

  def self.by_course_and_company(course_id, company_id)
    CoursePerson.where(course: course_id, company_id: company_id)
      .includes(:person, :company)
      .group(:person_id)
      .order(people: { last_name: :asc })
  end

  def register_renovation
    # aca estamos seteando el precio del modulo que va a tomar la persona
    # si el modulo es por turno, registramos el turno
    sectional_id = self.course.room.headquarter.sectional.id
    self.price = (self.is_free) ? 0 : self.unit.get_price(sectional_id, self.company_id)
    course_type_unit = CourseTypeUnit.find_by(course_type_id: self.course.course_type_id, unit_id: self.unit_id)
    if course_type_unit.is_by_turn
      self.from_hour = set_hour(course_unit.unit_id, self.course_id, self.date, course_type_unit.shift_time)
      self.to_hour = self.from_hour + course_type_unit.shift_time.minutes
    end
    self.save
  end

  def status_theoric
    cp = CoursePerson
      .where(person: self.person, course: self.course)
      # .where(date: Date.today..Date.today - 30.days)
      .joins(:unit)
      .where(units: { category: "Teorico" })
    if !cp.blank?
      if cp.first.scoring?
        nota = [ cp.first.scoring, cp.first.make_up_1, cp.first.make_up_2 ].max
        nota >= 90 ? "Aprobado" : "Desaprobado"
      else
        "Sin nota"
      end
    else
      "Sin nota"
    end
  end

  def scoring_theoric
    # devuelvo la nota mas alta de las 3 instancias que tiene el teorico
    cp = CoursePerson
      .where(person: self.person, course: self.course)
      .joins(:unit)
      .where(units: { category: "Teorico" })
      .pluck(:scoring, :make_up_1, :make_up_2)
    scoring = (cp.blank?) ? 0 : cp[0].max
    scoring
  end

  def las_theoric_data
    cp = CoursePerson
      .where(person: self.person, course: self.course)
      .joins(:unit)
      .where(units: { category: "Teorico" })
    notas = cp.pluck(:scoring, :make_up_1, :make_up_2)
    scoring = (notas.blank?) ? 0 : notas[0].max
    "#{cp.last.date.strftime("%d/%m/%Y")} #{scoring}"
  end

  def scoring_practica
    cp = CoursePerson
      .where(person: self.person, course: self.course)
      # .where(date: Date.today..Date.today - 30.days)
      .joins(:unit)
      .where(units: { category: "Practico" })
    if !cp.blank?
      cp.first.update(make_up_1: 0, make_up_2: 0)

      if cp.first.scoring?
        nota = [ cp.first.scoring, cp.first.make_up_1, cp.first.make_up_2 ].max
        nota
      else
        "Sin nota"
      end
    else
      "Sin nota"
    end
  end

  def set_code
    if self.unit.category == "Teorico" && self.course.code
      self.code = self.course.code
    end
  end

  def self.personas_con_teoria_desaprobada_o_ausente
    CoursePerson
      .joins(:person)
      .joins(:unit)
      .where(approved: false)
      .or(CoursePerson.where(attendance_status: :absent))
      .where(units: { category: "Teorico" })
      .select("people.name, people.last_name, people.cuil, people.id")
      .order("people.last_name")
  end

  def self.personas_con_psicometrico_desaprobada_o_ausente
    CoursePerson
      .joins(:person)
      .joins(:unit)
      .where(approved: false)
      .or(CoursePerson.where(attendance_status: :absent))
      .where(units: { category: "Psicometrico" })
      .select("people.name, people.last_name, people.cuil, people.id")
      .order("people.last_name")
  end

  def get_aprobado_text
    approved_units = CoursePerson.where(course_id: self.course_id, person_id: self.person_id).where(approved: true)
    if approved_units.count == 0
      text = "No ha aprobado ningun modulo"
    else
      text = "Aprobó "
      approved_units.each do |approved|
        preppend = (text.split.count > 1) ? "y " : ""
        if approved.unit.category == "Teorico"
          unit_text = "#{preppend} el curso #{approved.unit.name} "
        else
          unit_text = "#{preppend} la evaluación #{approved.unit.name} "
        end
        text += unit_text
      end
    end
    "#{text} en la Escuela de Conducción \n Defensiva del IAPG."
  end

  def self.check_approved(id)
    # tengo que disparar esto para el desaprobado
    course_person = CoursePerson.find_by(id: id) # id del primer modulo
    # obtenemos todos los modulos en los q se registro esta persona en ese curso
    course_people = CoursePerson.where(person: course_person.person, course: course_person.course)
    # recorro los modulos para chequear todas las notas y si esta aprobado
    # tengo que buscarle la vuelta para no hacer todo este trabajo siempre
    course_people.each do |cp|
      unit_category = cp.unit.category
      next if unit_category == "Psicometrico"
      next if cp.scoring.nil? && cp.make_up_1.nil? && cp.make_up_2.nil?
      if unit_category == "Teorico"
        number_approved = 80
      else
        number_approved = 2
      end
      cp.make_up_1 = 0 if cp.make_up_1.nil?
      cp.make_up_2 = 0 if cp.make_up_2.nil?
      approved = (cp.scoring >= number_approved || cp.make_up_1 >= number_approved || cp.make_up_2 >= number_approved)
      # si tiene nota registada es que la persona asistio, en ese caso actualizamos el estado
      attendance_status = (cp.scoring > 0 || cp.make_up_1 > 0 || cp.make_up_2 > 0) ? :presence : nil
      if attendance_status.nil?
        cp.update(approved: approved)
      else
        cp.update(approved: approved, attendance_status: attendance_status)
      end
    end
  end

  def get_credential_status
    limit_date = Date.today - 2.years
    courses_of_person = CoursePerson
                          .joins(:course)
                          .joins(:course_unit)
                          .joins(course_unit: :unit)
                          .where(person_id: self.person_id, approved: true)
                          .where("courses.from_date >= #{limit_date}")
                          .select("course_people.id, course_people.person_id, units.category")
                          .pluck(:category)
    if courses_of_person.empty? || !courses_of_person.include?("Teorico")
      "Falta teorico"
    elsif !courses_of_person.include?("Practico")
      "Falta practica"
    elsif !courses_of_person.include?("Psicometrico")
      "Falta psicometrico"
    else
      "Aprobado"
    end
  end

  def set_expiration_date
    years_of_duration = (self.company&.credential_years.blank?) ? self.course.years_of_duration : self.company.credential_years
    self.expiration_date = self.date + years_of_duration.years
  end

  def register_particular
    self.unit = self.course_unit.unit
    self.course = self.course_unit.course
    self.date = self.course_unit.date
    self.price = self.unit.get_particular_price(self.course.room.headquarter.sectional.id)
    self.quota_type = :particular
    self.date = self.course.from_date
    self.save
  end

  def check_introductory_course
    # si el curso es de inicio, no deberia tener ningun curso hecho
    # para poder anotarse
    if self.course.course_type.category == "Inicio"
      exist_course = CoursePerson.where(person: self.person, approved: true)
      if exist_course.any?
        errors.add(:person_id, "Esta persona ya tiene cursos realizados.")
      end
    end
  end

  def check_renovation_course
    # si el curso es de renovacion, deberia tener ningun curso hecho
    # para poder anotarse
    if self.course.course_type.category == "Renovacion"
      exist_course = CoursePerson.where(person: self.person, approved: true)
      errors.add(:person_id, "Esta persona no ha hecho un inicio.") if exist_course.empty?
    end
  end

  def get_price # obtenemos el precio de todo el curso, no solo de este registro
    CoursePerson.actives.where(course: self.course, person: self.person).where(is_free: false).sum(:price)
  end

  def amount_owed
    CoursePerson.actives.where(course: self.course, person: self.person, is_free: false, invoiced: false).sum(:price)
  end

  def check_status
    records = CoursePerson.actives.where(person: self.person, course: self.course).group(:pay_status).count
    if !records["no_pay"].nil?
      "Pendiente"
    elsif !records["invoiced"].nil?
      "Facturado"
    else
      "Pagado"
    end
  end

  def invoice_price
    (self.is_free) ? "Bonificado" : "$#{self.price}.00"
  end
end
