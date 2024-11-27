class FleetCategory < ApplicationRecord
  scope :actives, -> { where(active: true) }
end
