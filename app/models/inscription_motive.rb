class InscriptionMotive < ApplicationRecord
  scope :actives, -> { where(active: true) }
end
