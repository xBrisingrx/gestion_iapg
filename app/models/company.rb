class Company < ApplicationRecord
  belongs_to :iva_condition
  belongs_to :company_category
  belongs_to :sector, optional: true
  belongs_to :province, optional: true
  belongs_to :city, optional: true
  has_many :company_managers

  validates :name,
    presence: true,
    uniqueness: { message: "Esta empresa ya se encuentra registrada." }

  validates :cuit,
    presence: true,
    uniqueness: { message: "Este cuit pertenece a otra empresa" }

  before_validation :set_province

  scope :actives, -> { where(active: true) }

  def self.ransackable_attributes(auth_object = nil)
    [ "cuit", "id", "id_value", "name", "sector_id", "company_category_id" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "sector", "company_category" ]
  end

  def disable
    self.update(active: false)
  end

  private
  def set_province
    self.province = self.city.province if !self.city_id.blank?
  end
end
