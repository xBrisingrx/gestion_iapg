class City < ApplicationRecord
  belongs_to :province

  validates :name,
    presence: true,
    uniqueness: { case_sensitive: false, scope: :province_id }
end
