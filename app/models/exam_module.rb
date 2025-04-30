class ExamModule < ApplicationRecord
  belongs_to :exam
  has_many :module_videos
  has_many :videos, through: :module_videos
  has_many :module_questions
  has_many :questions, through: :module_questions
  scope :actives, -> { where(active: true) }

  # before_create :set_module_order

  private
  def set_module_order
    module_order = self.exam.exam_modules.order(module_order: :desc)
    if module_order.blank?
      self.module_order = 1
    else
      self.module_order = module_order.first.module_order + 1
    end
  end
end
