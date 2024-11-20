class Sector < ApplicationRecord
  validates :name,
    presence: true,
    uniqueness: { message: "Este rubro ya se encuentra registrado." }

  scope :actives, -> { where(active: true) }

  def self.filter(query)
    sector = Sector.select(:id, :name, :description).actives
    if !query.blank?
      sector = sector
                .where("name LIKE ?", "%#{query}%")
                .or(Sector.where("description LIKE ?", "%#{query}%"))
    end
    sector.order(name: :asc)
  end
end
