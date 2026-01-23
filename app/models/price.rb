class Price < ApplicationRecord
  belongs_to :unit
  belongs_to :sectional, optional: true
  belongs_to :company, optional: true

  scope :actives, -> { where(active: true) }

  enum :client_type, [ :empresa, :particular ]
  before_create :set_end_date

  def self.ransackable_attributes(auth_object = nil)
    [ "active", "price", "client_type", "sectional_id",
      "id", "id_value", "company_id", "unit_id", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "sectional", "company", "unit" ]
  end

  private
  def set_end_date
    self.end_date = self.start_date + 6.months
  end
end
