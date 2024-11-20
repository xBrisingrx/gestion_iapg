class Headquarter < ApplicationRecord
  belongs_to :sectional
  belongs_to :province, optional: true
  belongs_to :city, optional: true

  validates :name,
    presence: true,
    uniqueness: { message: "Esta sede ya se encuentra registrada." }

  before_validation :set_city
  before_validation :set_province

  scope :actives, -> { where(active: true) }

  def self.ransackable_attributes(auth_object = nil)
    [ "id", "name", "description", "province_id", "city_id", "sectional_id", "can_make_psychometric" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "sectional", "city", "province" ]
  end

  private
  def set_city
    city = City.find_by(name: self.location)
    if city
      self.city = city
    end
  end

  def set_province
    self.province = self.city.province if !self.city_id.blank?
  end
end
