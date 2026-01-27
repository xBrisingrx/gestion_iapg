class IncoiveItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :course_people
end
