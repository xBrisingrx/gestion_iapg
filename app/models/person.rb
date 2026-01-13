class Person < ApplicationRecord
  belongs_to :province, optional: true
  belongs_to :city, optional: true
  has_many :course_people

  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_to_limit: [ 100, 100 ]
  end
  has_many_attached :psicometrics
  normalizes :email, with: ->(email) {  email.strip.downcase }

  validates :name, :last_name, :cuil, :birthdate, :phone, :celphone, :email, :direction, presence: true
  validates :cuil, uniqueness: { message: "Ya existe una persona registrada con este cuil." }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "debe ingresar un  email  válido" }
  before_save :set_province

  scope :actives, -> { where(active: true) }

  def disable
    self.update(active: false)
  end

  def fullname
    "#{self.last_name} #{self.name}"
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "active", "birthdate", "celphone", "city_id", "code", "created_at", "cuil", "direction",
      "email", "id", "id_value", "last_name", "name", "phone", "province_id", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "city", "province" ]
  end

  def update_attendance_status_last_psicometric
    last_psicometric = CoursePerson.where(person: self).joins(:unit).where(unit: { category: "Psicometrico" }).last
    last_psicometric.update(attendance_status: :presence, approved: true)
  end

  private
  def set_province
    self.province = Province.find(self.city.province.id) if !self.city_id.blank?
  end
end
