class ModuleQuestion < ApplicationRecord
  belongs_to :exam_module
  belongs_to :question

  scope :actives, -> { where(active: true) }

  validates :question_order, presence: true

  # before_validation :set_question_order

  def disable
    self.update(active: false)
  end

  private
  def set_question_order
    question_order = self.exam_module.module_questions.actives.order(question_order: :desc)
    if question_order.blank?
      self.question_order = 1
    else
      self.question_order = question_order.first.question_order + 1
    end
  end
end
