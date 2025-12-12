class PriceCourse < ApplicationRecord
  belongs_to :course_type
  scope :actives, -> { where(active: true) }

  before_create :set_end_date

  def self.filter(query)
    price_courses = PriceCourse.select(:id, :price, :start_date, :course_type_id).actives.joins(:course_type)
    if !query.blank?
      price_courses = price_courses
                .where("price LIKE ?", "%#{query}%")
                .or(price_courses.where("course_types.name LIKE ?", "%#{query}%"))
    end
    price_courses.order(price: :asc)
  end

  private
  def set_end_date
    self.end_date = self.start_date + 1.years
  end
end
