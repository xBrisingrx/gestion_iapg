class Answer < ApplicationRecord
  belongs_to :question

  scope :actives, -> { where(active: true) }
end
