module CalendarHelper
  def month_offset(date)
    if date.beginning_of_month.wday == 0
      6
    else
      date.beginning_of_month.wday - 1
    end
  end

  def today?(date)
    date == Date.today
  end

  def today_class(date)
    "bg-calendar-today" if today?(date)
  end
end
