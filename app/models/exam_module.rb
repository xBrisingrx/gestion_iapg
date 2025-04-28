class ExamModule < ApplicationRecord
  belongs_to :exam
  scope :actives, -> { where(active: true) }
end
