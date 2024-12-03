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

  attr_accessor :practical_turn_id, :psicometrico_turn_id

  def assign_turn
    # metodo mal hecho porq lo llamamos de una instancia que no guardamos nunca
    # return if self.course.course_type.days == 1 || CoursePerson.where(course_id: self.course_id, person_id: self.person_id).count > 1
    course_units = CourseUnit.where(course_id: self.course_id).group(:unit_id)
    course_date = self.course.from_date
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
end
