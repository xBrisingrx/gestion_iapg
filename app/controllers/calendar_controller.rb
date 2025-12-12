class CalendarController < ApplicationController
  def admin
    month
  end

  def clients
    month
  end
  def month
    @date = Date.parse(params.fetch(:date, Date.today.to_s))
    @weekdays = { "Sun" => "Dom", "Mon" => "Lun", "Tue" => "Mar", "Wed" => "Mier", "Thu" => "Jue", "Fri" => "Vier", "Sat" => "Sab" }
    @courses = Course.where(from_date: @date.all_month).group_by { |c| c.from_date.to_date }
  end
end
