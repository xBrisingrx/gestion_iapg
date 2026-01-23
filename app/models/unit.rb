class Unit < ApplicationRecord
  # modelamos los modulos de los cursos
  has_many :prices
  validates :name, :fleet, :methodology, :category, presence: true

  scope :actives, -> { where(active: true) }

  def self.ransackable_attributes(auth_object = nil)
    [ "id", "name", "description", "fleet", "methodology", "category" ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  def disable
    self.update(active: false)
  end

  def last_price
    prices = self.prices.actives
    price = (prices.blank?) ? 0 : prices.last&.price
    price
  end

  def get_price (sectional_id, company_id = nil)
    unit_prices = self.prices.actives.where(sectional_id: sectional_id, company_id: company_id, client_type: :empresa)
    if unit_prices.empty? # la empresa no tiene contrato, entonces no filtramos por empresa
      unit_prices = self.prices.actives.where(sectional_id: sectional_id, company_id: nil, client_type: :empresa)
    end
    price = (unit_prices.any?) ? unit_prices.last.price : 0
    price
  end
end
