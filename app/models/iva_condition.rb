class IvaCondition < ApplicationRecord
  validates :name,
    presence: true,
    uniqueness: { message: "Esta condición de IVA ya se encuentra registrada" }

  scope :actives, -> { where(active: true) }

  def self.filter(query)
    iva_conditions = IvaCondition.select(:id, :name, :description).actives
    if !query.blank?
      iva_conditions = iva_conditions
                .where("name LIKE ?", "%#{query}%")
                .or(IvaCondition.where("description LIKE ?", "%#{query}%"))
    end
    iva_conditions.order(name: :asc)
  end
end
