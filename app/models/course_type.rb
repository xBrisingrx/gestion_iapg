class CourseType < ApplicationRecord
  belongs_to :room
  has_many :courses
  has_many :course_type_units
  has_many :units, through: :course_type_units

  validates :description, :min_quota, :max_quota, :min_score, :max_score, :passing_score, :number_of_repeat, :fleet, :category, presence: true
  validates :min_quota, :max_quota, :min_score, :max_score, :passing_score, :number_of_repeat, numericality: { only_integer: true }
  validates :name,
    presence: true,
    uniqueness: { message: "Este tipo de curso ya se encuentra registado." }

  scope :actives, -> { where(active: true) }

  enum :fleet, [ :light, :heavy, :both ] # discriminamos si el tipo de curso es de flota liviana o pesada

  def self.ransackable_attributes(auth_object = nil)
    [ "id", "name", "description", "min_quota", "max_quota", "min_score", "max_score", "passing_score", "number_of_repeat", "room_id", "need_code" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "room" ]
  end

  def disable
    self.update(active: false)
  end

  def count_yearly_number
    self.courses
      .actives
      .by_year(Time.now.year)
      .count
  end

  def units_information_by_day
    return Array.new if self.course_type_units.count == 0
    units_by_day = Array.new
    day = self.course_type_units.first.day
    units = Array.new
    self.course_type_units.each do |unit|
      if day != unit.day
        units_by_day << units
        units = Array.new
        day = unit.day
      end
      units << [
        unit.unit.name,
        unit.schedule
      ]
    end
    units_by_day
  end

  def days
    self.course_type_units.select(:day).distinct.count
  end

  def self.unit_of_theory
    self.joins(:course_type_unit).where(units: { category: "Teorico" }).first
  end

  def price
    unit_prices = 0
    self.units.group(:unit_id).map { |unit| unit_prices = unit_prices + unit.last_price }
    unit_prices
  end
end
