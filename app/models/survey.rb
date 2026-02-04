class Survey < ApplicationRecord
  belongs_to :course
  belongs_to :person
end
