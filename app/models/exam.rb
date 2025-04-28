class Exam < ApplicationRecord
  has_many :exam_questions
  has_many :questions, through: :exam_questions
  scope :actives, -> { where(active: true) }

  before_save :set_retake

  def disable
    self.update(active: false)
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "id", "title" ]
  end

  private
  def set_retake
    self.retake = "" if self.retake == "0"
    self.retake = "#{self.retake}.º" if self.retake.to_i > 0
  end
end
