class CourseTypeUnit < ApplicationRecord
  belongs_to :course_type
  belongs_to :unit

  validates :shift_time,
    presence: { message: "Debe aclarar el tiempo de cada turno" },
    if: :unit_is_by_turn?
  validates :start_hour, :end_hour, presence: true
  validate :start_hour_less_than_end_hour
  validates :unit, uniqueness: { scope: [:shift, :course_type_id, :day] }
  validate :hour_available

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
    
  end
end
