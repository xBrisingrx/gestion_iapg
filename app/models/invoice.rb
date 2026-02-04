class Invoice < ApplicationRecord
  belongs_to :company
  has_many :invoice_items, dependent: :destroy
  has_many :course_people, through: :invoice_items
  accepts_nested_attributes_for :invoice_items

  before_create :generate_number

  def self.ransackable_attributes(auth_object = nil)
    [ "id", "number", "status", "company_id", "date", "created_at",
    "id_value", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "company" ]
  end

  def total
    self.course_people.sum(:price)
  end

  private
  def generate_number
    self.number = Invoice.all.count + 1
  end
end
