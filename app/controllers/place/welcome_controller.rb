class Place::WelcomeController < Place::BaseController
  PlaceAccountStatus = Struct.new(:date, :school, :commission) do
    def total
      school + commission
    end
  end

  def index
    account_status_by_date = place.incomes.select('date, sum(payment_amount) as amount').group('date').each_with_object({}) do |obj, hash|
      hash[obj.date] = PlaceAccountStatus.new(obj.date, obj.amount, 0)
    end

    place.expenses.select('date, -sum(payment_amount) as amount').group('date').each do |obj|
      account_status_by_date[obj.date] ||= PlaceAccountStatus.new(obj.date, 0, 0)
      account_status_by_date[obj.date].commission = obj.amount
    end

    @account_status = []
    account_status_by_date.keys.sort_by { |e| - e.to_time.to_i }.each do |s|
      @account_status << account_status_by_date[s]
    end
  end
end
