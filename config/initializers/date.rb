class Date
  def next_week
    self + (7 - self.wday)
  end

  def next_wday (n)
    n > self.wday ? self + (n - self.wday) : self.next_week.next_day(n)
  end

  def to_human
    if year == Date.today.year
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
end
