class Date
  def next_week
    self + (7 - self.wday)
  end

  def next_wday (n)
    n > self.wday ? self + (n - self.wday) : self.next_week.next_day(n)
  end

  def to_human
    if year == Date.today.year
      strftime("%a %e %b")
    else
      strftime("%a %e %b %Y")
    end
  end
end
