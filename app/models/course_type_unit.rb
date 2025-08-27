class CourseTypeUnit < ApplicationRecord
  belongs_to :course_type
  belongs_to :unit
  has_many :course_hours_turns

  validates :shift_time,
    presence: { message: "Debe aclarar el tiempo de cada turno" },
    if: :unit_is_by_turn?
  validates :start_hour, :end_hour, :days_of_duration, presence: true
  validate :start_hour_less_than_end_hour
  validates :unit, uniqueness: { scope: [ :shift, :course_type_id, :day ] }
  # validate :hour_available, on: :create

  after_create :generate_hours_turns

  def schedule
    "De #{self.start_hour&.strftime("%k:%M")} a #{self.end_hour&.strftime("%k:%M")}"
  end

  def calc_quota # calculamos cuantos cupos entran en un turno
    return "--" if !self.is_by_turn
    diff_in_minutes = (self.end_hour - self.start_hour) / 60
    (diff_in_minutes / self.shift_time).to_i
  end

  private
  def start_hour_less_than_end_hour
    return if self.start_hour.nil? || self.end_hour.nil?
    if self.start_hour >= self.end_hour
      errors.add :start_hour, "Hora inicio debe ser menor a hora fin"
      errors.add :end_hour, "Hora fin debe ser mayor a hora inicio"
    end
  end

  def unit_is_by_turn?
    self.is_by_turn
  end

  def hour_available
    # no puedo agregar modulos en el mismo horario el mismo dia
    course_type_units = CourseTypeUnit.where(course_type: self.course_type, day: self.day)
    course_type_units.each do |ctu|
      record = CourseTypeUnit.where(course_type: ctu.course_type)
                              .where(start_hour: ctu.start_hour..ctu.end_hour)
                              .or(CourseTypeUnit.where(end_hour: ctu.end_hour..ctu.end_hour))
      if !record.blank?
        errors.add(:start_hour, "El horario se encuentra ocupado.") unless start_hour.blank?
        return
      end
    end
  end

  def self.unit_of_theory(course_type_id)
    CourseTypeUnit.joins(:unit).where(course_type_id: course_type_id).where(units: { category: "Teorico" }).first
  end

  def generate_hours_turns
    if self.is_by_turn
      turn_hour = self.start_hour
      while turn_hour < self.end_hour
        self.course_hours_turns.create(
          hour: turn_hour
        )
       turn_hour += self.shift_time.minutes
      end
    end
  end
end
