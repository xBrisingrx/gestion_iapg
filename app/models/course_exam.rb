class CourseExam < ApplicationRecord
  belongs_to :course
  belongs_to :exam

  enum :fleet, [ :light, :heavy, :both ]
end
