class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :course_person
  has_one :course, through: :course_person
  has_one :person, through: :course_person

  attr_accessor :set_free

  after_create :update_course_person
  after_update :set_payments

  private
  def update_course_person
    self.course_person.pay_status = :invoiced
    self.course_person.status = "Facturado"
    self.course_person.invoiced = true
    if self.set_free
      self.course_person.is_free = true
    end
    self.course_person.save
  end

  def set_payments
    debugger
    self.course_person.pay_status = :pay
    if self.set_free
      self.course_person.is_free = true
    end
    self.course_person.save
  end
end
