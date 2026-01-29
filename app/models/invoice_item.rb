class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :course_person
  has_one :course, through: :course_person
  has_one :person, through: :course_person


  after_create :update_course_person_status

  private
  def update_course_person_status
    self.course_person.update(pay_status: :invoiced, status: "Facturado")
  end
end
