class Room < ApplicationRecord
  belongs_to :headquarter

  validates :name,
    presence: true,
    uniqueness: { scope: :headquarter_id, message: "Esta sala ya se encuentra registrada." }

  validates :capacity,
    presence: true,
    numericality: { only_integer: true }

  scope :actives, -> { where(active: true) }

  def self.ransackable_attributes(auth_object = nil)
    [ "id", "name", "description", "capacity", "headquarter_id" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "headquarter" ]
  end
end
