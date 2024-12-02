class CalendarController < ApplicationController
  def month
    @date = Date.parse(params.fetch(:date, Date.today.to_s))
    @courses = Course.where(from_date: @date.all_month).group_by { |c| c.from_date.to_date }
  end
end
