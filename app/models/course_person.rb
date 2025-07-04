class CoursePerson < ApplicationRecord
  belongs_to :course
  belongs_to :person
  belongs_to :manager, class_name: "Person"
  belongs_to :company
  belongs_to :operator, class_name: "Company"
  belongs_to :inscription_motive
  belongs_to :fleet_category
  belongs_to :unit
  belongs_to :course_unit
  has_one :turn

  enum :attendance_status, [ :no_registeder, :presence, :absent, :no_documents ]

  attr_accessor :practical_turn_id, :psicometrico_turn_id

  before_create :set_code
  # after_update :check_approved

  def assign_turn
    # metodo mal hecho porq lo llamamos de una instancia que no guardamos nunca
    # return if self.course.course_type.days == 1 || CoursePerson.where(course_id: self.course_id, person_id: self.person_id).count > 1
    course_units = CourseUnit.where(course_id: self.course_id).group(:unit_id)
    course_date = self.course.from_date
    # debugger
    ActiveRecord::Base.transaction do
      course_units.each do |course_unit|
        next if CoursePerson.find_by(course_id: self.course_id, person_id: self.person_id, unit_id: course_unit.unit_id)
        course_type_unit = CourseTypeUnit.find_by(course_type_id: self.course.course_type_id, unit_id: course_unit.unit_id)
        course_person = CoursePerson.new(
          course_id: self.course_id,
          person_id: self.person_id,
          manager_id: self.manager_id,
          company_id: self.company_id,
          operator_id: self.operator_id,
          inscription_motive_id: self.inscription_motive_id,
          fleet_category_id: self.fleet_category_id,
          unit_id: course_unit.unit_id,
          course_unit_id: course_unit.id
        )
        course_person.date = course_date + (course_unit.day - 1).day
        if course_type_unit.is_by_turn
          # if course_type_unit.unit.category == "Psicométrico"
          #   turn_id = self.psicometrico_turn_id
          # end

          # if course_type_unit.unit.category == "Práctico"
          #   turn_id = self.practical_turn_id
          # end

          course_person.from_hour = set_hour(course_unit.unit_id, self.course_id, course_person.date, course_type_unit.shift_time)
          # course_person.from_hour = set_turn(turn_id, course_person.date, course_type_unit.shift_time)
          course_person.to_hour = course_person.from_hour + course_type_unit.shift_time.minutes
        end
        course_person.save
        raise ActiveRecord::Rollback if course_person.id.nil?
      end # end course_units.each
    end # end transaction
  end

  def set_turn(turn_id, date, shift_time)
    turn = Turn.find(turn_id)
    if self.person_is_available(shift_time, date, turn.hour)
      turn.update(available: false, person_id: self.person_id, status: :busy)
      turn.hour
    else
      errors.add(:psicometrico_turn_id, "Los horarios se superponen.")
      errors.add(:practical_turn_id, "Los horarios se superponen.")
      raise ActiveRecord::Rollback
    end
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

  def register_renovation
    self.unit = self.course_unit.unit
    self.course = self.course_unit.course
    self.date = self.course_unit.date
    course_type_unit = CourseTypeUnit.find_by(course_type_id: self.course.course_type_id, unit_id: self.course_unit.unit_id)
    if course_type_unit.is_by_turn
      self.from_hour = set_hour(course_unit.unit_id, self.course_id, self.date, course_type_unit.shift_time)
      # self.from_hour = set_turn(turn_id, self.date, course_type_unit.shift_time)
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
      if cp.first.scoring
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
    cp = CoursePerson
      .where(person: self.person, course: self.course)
      .joins(:unit)
      .where(units: { category: "Teorico" })
    if !cp.blank?
      cp.first.scoring
    else
      ""
    end
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
    course_person = CoursePerson.find_by(id: id)
    unit_category = course_person.unit.category
    if unit_category == "Teorico"
      number_approved = 80
    else
      number_approved = 2
    end
    approved = (course_person.scoring >= number_approved || course_person.make_up_1 >= number_approved || course_person.make_up_2 >= number_approved)
    course_person.update(approved: approved)
  end

  def get_credential_status
    limit_date = Date.today - 2.years
    courses_of_person = CoursePerson
                          .joins(:course)
                          .joins(:course_unit)
                          .joins(course_unit: :unit)
                          .where(person_id: self.person_id, approved: true)
                          .where("courses.from_date >= #{limit_date}")
                          .select("course_people.id, course_people.person_id, units.category")pluck
  end
end
