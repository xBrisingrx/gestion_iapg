class Question < ApplicationRecord
  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
  end
  validates :question,
    presence: true,
    uniqueness: { message: "Esta pregunta ya se encuentra registrada" }

  scope :actives, -> { where(active: true) }

  def self.filter(query)
    questions = Question.select(:id, :question, :eliminating).actives
    if !query.blank?
      questions = questions.where("question LIKE ?", "%#{query}%")
    end
    questions.order(question: :asc)
  end
end
