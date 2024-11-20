class Instructor < ApplicationRecord
  belongs_to :person

  scope :actives, -> { where(active: true) }

  validates :person_id, uniqueness: { message: "Este instructor ya esta registrado." }
  validates :code, uniqueness: { allow_blank: true ,message: "Este código ya esta en uso" }
  validates :start_date, presence: true
  validates :end_date, presence: true, if: :instructor_inactive?

  def disable
    self.update(active: false)
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "person_id", "code" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "person"]
  end

  private
  def instructor_inactive?
    !self.active
  end
end
