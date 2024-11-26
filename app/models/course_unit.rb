class CourseUnit < ApplicationRecord
  # aca tenemos la info del curso y las unidades/modulos que tiene
  # registramos quien lo dicta, en que turno y que horario
  belongs_to :course
  belongs_to :unit
  belongs_to :instructor
  has_many :turns

  validates :start_hour, :end_hour, presence: true
  validate :start_hour_less_than_end_hour

  before_create :set_date
  after_create :generate_turns

  def schedule
    "De #{self.start_hour&.strftime("%k:%M")} a #{self.end_hour&.strftime("%k:%M")}"
  end

  def is_by_turn
    CourseTypeUnit.find_by(course_type: self.course.course_type, unit: self.unit).is_by_turn
  end

  def shift_time
    CourseTypeUnit.find_by(course_type: self.course.course_type, unit: self.unit).shift_time
  end

  def lists
    lists = Course.find(self.course_id).course_units.where(unit_id: self.unit_id).select(:n_list).distinct.count
    lists
  end

  private

  def set_date
    self.date = self.course.from_date + (self.day - 1).day
  end

  def generate_turns
    course_type_unit = CourseTypeUnit.find_by(course_type_id: self.course.course_type_id, unit_id: self.unit_id)
    return if !course_type_unit.is_by_turn
    turn_hour = self.start_hour
    date = self.date
    while turn_hour < self.end_hour
      self.turns.create(
        course_id: self.course_id,
        unit_id: self.unit_id,
        date: date,
        hour: turn_hour,
        n_list: self.n_list
      )
      turn_hour += course_type_unit.shift_time.minutes
    end
  end

  def start_hour_less_than_end_hour
    return if self.start_hour.nil? || self.end_hour.nil?
    if self.start_hour >= self.end_hour
      errors.add :start_hour, "Hora inicio debe ser menor a hora fin"
      errors.add :end_hour, "Hora fin debe ser mayor a hora inicio"
    end
  end
end
