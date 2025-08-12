class Turn < ApplicationRecord
  belongs_to :course
  belongs_to :person, optional: true
  belongs_to :unit
  belongs_to :course_unit

  # validates :name, presence: true

  enum :status, [ :available, :busy, :reserved ]

  def change_to(change_to_turn_id)
    turn = Turn.find_by(id: change_to_turn_id)
    turn.update(person: self.person, status: :busy)
    self.update(person: nil, status: :available)
  end
end
