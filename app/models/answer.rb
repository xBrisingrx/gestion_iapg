class Answer < ApplicationRecord
  belongs_to :question

  scope :actives, -> { where(active: true) }

  before_save :check_correct,
    if: ->(answer) { answer.correct }

  private
  def check_correct
    question = self.question
    answers = question.answers.where(correct: true)
    if answers.count > 0
      answers.update_all(correct: false)
    end
  end
end
