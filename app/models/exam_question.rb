class ExamQuestion < ApplicationRecord
  belongs_to :exam
  belongs_to :question

  scope :actives, -> { where(active: true) }

  before_create :set_order

  def disable
    order = self.question_order
    self.update(active: false, question_order: 0)
    exam_questions = ExamQuestion.where("exam_id = ? AND active = ? AND question_order > ?", self.exam_id, true, order)
    exam_questions.each do |eq|
      new_order = eq.question_order - 1
      eq.update(question_order: new_order)
    end
  end

  private
  def set_order
    # obtenemos la ultima pregunta segun su orden o la nueva seria la siguiente
    exam = self.exam
    last_question = exam.exam_questions.actives.order(question_order: :desc)
    if last_question.empty?
      self.question_order = 1
    elsif
      self.question_order = last_question.first.question_order + 1
    end
  end
end
