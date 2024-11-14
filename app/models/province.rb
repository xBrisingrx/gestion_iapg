class Province < ApplicationRecord
  validates :name, presence: true,
    uniqueness: { case_sensitive: false, message: "Ya existe una provincia registrada con este nombre" }
  scope :actives, -> { where(active: true) }
end
