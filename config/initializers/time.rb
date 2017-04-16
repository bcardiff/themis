class Time
  def to_human
    DateTime.parse(self.to_s).to_date.to_human
  end
end
