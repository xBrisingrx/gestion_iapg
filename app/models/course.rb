class Course < ApplicationRecord
  belongs_to :course_type
  belongs_to :room
  belongs_to :company, optional: true
  has_many :course_people, dependent: :destroy
  has_many :people, through: :course_people
  has_many :turns, dependent: :destroy
  has_many :course_units, dependent: :destroy
  has_many :units, through: :course_units
  has_many :instructors, through: :course_units
  has_many :course_exams, dependent: :destroy
  has_many :exams, through: :course_exams


  accepts_nested_attributes_for :course_units, reject_if: :all_blank
  accepts_nested_attributes_for :course_exams, reject_if: :exam_id_is_blank
  accepts_nested_attributes_for :course_people

  validates :year_number, uniqueness: { scope: [ :course_type_id, :general_number ], allow_blank: true }
  validates :general_number, uniqueness: { scope: :course_type_id, allow_blank: true }
  validates :from_date, presence: true
  validates :company_id, presence: true, if: :course_is_company

  scope :actives, -> { where(active: true) }
  scope :count_general_number, ->(course_type_id) { where(active: true).where(course_type_id: course_type_id).count }
  scope :by_year, ->(year) { where("extract(year from created_at) = ?", year) }

  before_create :set_to_date
  before_create :set_years_of_duration

  def disable
    self.update(active: false)
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "date", "room_id", "company_id", "course_type_id" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "room", "company", "course_type" ]
  end

  def cant_days
    self.course_type.course_type_units.select(:day).distinct.count
  end

  def exam_id_is_blank(attributes)
    attributes["exam_id"].blank?
  end

  def name
     self.course_type.name
  end

  def has_turns?
    # verifico si el curso tiene turnos disponibles
    # como la teoria suelen ser de a 100 personas nunca se llena
    categories = self.units.pluck(:category)
    (categories.include?("Teorico") || self.turns.where(status: :available).any?)
  end

  private
  def set_to_date
    days = self.course_type.days - 1
    self.to_date = self.from_date + days.day
  end

  def course_is_company
    self.is_company
  end

  def set_years_of_duration
    self.years_of_duration = self.course_type.duration
  end
end
