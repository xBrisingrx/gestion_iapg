class Province < ApplicationRecord
  has_many :cities
  validates :name, presence: true,
    uniqueness: { message: "Ya existe una provincia registrada con este nombre" }
  scope :actives, -> { where(active: true) }

  def self.ransackable_attributes(auth_object = nil)
    [ "id", "name" ]
  end
end
