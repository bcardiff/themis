class Date
  def next_week
    self + (7 - self.wday)
  end

  def next_wday (n)
    n > self.wday ? self + (n - self.wday) : self.next_week.next_day(n)
  end

  def to_human
    if year == School.today.year
      I18n.l(self, format: "%a %e %b")
    else
      I18n.l(self, format: "%a %e %b %Y")
    end
  end

  def to_dmy
    strftime("%d/%m/%Y")
  end

  def self.from_dmy(str)
    return nil if str.blank?
    Date.strptime(str, "%d/%m/%Y")
  end

  def month_range
    self.at_beginning_of_month..self.at_end_of_month
  end

  def calendar_range
    self.at_beginning_of_month.at_beginning_of_week..self.at_end_of_month.at_end_of_week
  end

  def first_week
    first_day = self.beginning_of_month
    if first_day.saturday? || first_day.sunday?
      first_day = first_day.next_wday(1)
    end
    first_day..(first_day+1.week-1.day)
  end

  def second_week
    f = first_week
    (f.begin + 1.week)..(f.end + 1.week)
  end

  def third_week
    f = second_week
    (f.begin + 1.week)..(f.end + 1.week)
  end
end
