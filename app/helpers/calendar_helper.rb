module CalendarHelper
  def calendar_weeks(date)
    start_date = date.beginning_of_month.beginning_of_week(:monday)
    end_date = date.end_of_month.end_of_week(:monday)
    (start_date..end_date).each_slice(7).to_a
  end

  def today?(date)
    date == Date.today
  end

  def calendar_day_class(day, month_date)
    classes = [ "calendar-day" ]
    classes << "calendar-day--today" if today?(day)
    classes << "calendar-day--out" if day.month != month_date.month
    classes.join(" ")
  end

  def course_event_class(course)
    category = course.course_type.category.to_s.downcase
    base = "calendar-event"
    modifier =
      if category.include?("teor")
        "calendar-event--theoric"
      elsif category.include?("pract")
        "calendar-event--practico"
      elsif category.include?("psico")
        "calendar-event--psicometrico"
      else
        nil
      end

    # In Company tiñe el evento aunque tenga categoría
    modifier = "calendar-event--company" if course.is_company

    [ base, modifier ].compact.join(" ")
  end
end
