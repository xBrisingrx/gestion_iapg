class Unit < ApplicationRecord
  # modelamos los modulos de los cursos
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
end
