class Turn < ApplicationRecord
  belongs_to :course
  belongs_to :person, optional: true
  belongs_to :unit
  belongs_to :course_unit

  # validates :name, presence: true

  enum :status, [ :available, :busy, :reserved ]
end
