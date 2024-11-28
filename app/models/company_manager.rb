class CompanyManager < ApplicationRecord
  belongs_to :company
  belongs_to :person

  scope :actives, -> { where(active: true) }
end
