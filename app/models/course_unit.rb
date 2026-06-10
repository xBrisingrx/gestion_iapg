class CourseUnit < ApplicationRecord
  # aca tenemos la info del curso y las unidades/modulos que tiene
  # registramos quien lo dicta, en que turno y que horario
  belongs_to :course
  belongs_to :unit
  belongs_to :instructor, optional: true
  has_many :turns

  validates :list, :start_hour, :end_hour, presence: true
  validate :start_hour_less_than_end_hour

  before_validation :set_date
  after_create :generate_turns


  # Lookup memoizado: una sola query, una sola vez por instancia.
  # course_type_unit con @course_type_unit ||= → la primera vez consulta la DB, la segunda devuelve la variable de instancia. Tres lookups idénticos se vuelven uno.
  def course_type_unit
    @course_type_unit ||= CourseTypeUnit.find_by(
      course_type_id: course.course_type_id,
      unit_id: unit_id,
      shift: shift
    )
  end
  
  # delegate :is_by_turn, :shift_time, to: :course_type_unit → Rails genera ambos métodos como course_type_unit.is_by_turn y course_type_unit.shift_time. Te ahorrás escribirlos.
  # allow_nil: true → si course_type_unit no existe (datos rotos), te devuelve nil en lugar de explotar con NoMethodError. Importante para defensive code.

  delegate :is_by_turn, :shift_time, to: :course_type_unit, allow_nil: true

  def schedule
    "De #{self.start_hour&.strftime("%k:%M")} a #{self.end_hour&.strftime("%k:%M")}"
  end

  # def course_type_unit
  #   @course_type_unit ||= CourseTypeUnit.find_by(course_type: course.course_type, unit: unit)
  # end

  # def shift_time
  #   CourseTypeUnit.find_by(course_type: self.course.course_type, unit: self.unit).shift_time
  # end

  def lists
    lists = Course.find(self.course_id).course_units.where(unit_id: self.unit_id).select(:list).distinct.count
    lists
  end

  def is_by_turn
    course_type = self.course.course_type
    course_type_unit = CourseTypeUnit.find_by(course_type: course_type, unit: self.unit)
    course_type_unit.is_by_turn
  end

  private

  def set_date
    self.date = self.course.from_date + (self.day - 1).day
  end

  def generate_turns
    course_type_unit = CourseTypeUnit.find_by(course_type_id: self.course.course_type_id, unit_id: self.unit_id, shift: self.shift)
    return if !course_type_unit.is_by_turn
    # turn_hour = self.start_hour
    date = self.date
    turn_hours = CourseHoursTurn.where(course_type_unit: course_type_unit)

    turn_hours.each do |turn_hour|
      self.turns.create(
        course_id: self.course_id,
        unit_id: self.unit_id,
        date: date,
        hour: turn_hour.hour,
        list: self.list,
        status: :available
      )
    end
  end

  def start_hour_less_than_end_hour
    return if self.start_hour.nil? || self.end_hour.nil?
    if self.start_hour >= self.end_hour
      errors.add :start_hour, "Hora inicio debe ser menor a hora fin"
      errors.add :end_hour, "Hora fin debe ser mayor a hora inicio"
    end
  end

  def validate_instuctor_is_available
    instructor = CourseUnit.filter_instructors_by_date_and_hour(self.instructor_id, self.date, self.start_hour, self.end_hour)
    errors.add :instructor_id, "El instructor no esta disponible en ese horario" unless instructor.empty?
  end

  def self.filter_instructors_by_date_and_hour(instructor_id, date, start_hour, end_hour)
    # verificamos que el instructor ese dia a esa hora este disponible
    # inicio = start_hour.strftime("%H %M").gsub(" ", ":").to_datetime + 3.hours
    inicio = Time.zone.parse(start_hour) # aca me acomoda la hora que le paso a UTC 0
    # fin = end_hour.strftime("%H %M").gsub(" ", ":").to_datetime + 3.hours
    fin = Time.zone.parse(end_hour)
    instructors = CourseUnit
      .where(instructor_id: instructor_id)
      .where(date: date)
    instructor = instructors
      .where("start_hour >= ?", inicio)
      .where("end_hour <= ?", fin)
      .or(
        instructors
          .where("start_hour <= ?", fin)
          .where("end_hour >= ?", inicio))
    instructor
  end
end
