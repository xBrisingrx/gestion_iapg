class Person < ApplicationRecord
  belongs_to :province, optional: true
  belongs_to :city, optional: true

  normalizes :email, with: ->(email) {  email.strip.downcase }

  validates :name, :last_name, :cuil, :birthdate, :phone, :celphone, :email, :direction, presence: true
  validates :cuil, uniqueness: { case_sensitive: true, message: "Ya existe una persona registrada con este cuil." }

  before_save :set_province

  scope :actives, -> { where(active: true) }

  def disable
    self.update(active: false)
  end

  def fullname
    "#{self.last_name} #{self.name}"
  end

  private
  def set_province
    self.province = Province.find(self.city.province.id) if !self.city_id.blank?
  end
end
