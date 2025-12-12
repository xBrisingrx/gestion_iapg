class PersonExam < ApplicationRecord
  # aca guardamos las respuestas de una persona en un examen
  belongs_to :person
  belongs_to :exam
  belongs_to :course
  belongs_to :question
  belongs_to :answer
end
