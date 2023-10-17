module TeacherCashIncomes
  class PlaceInsuranceExpense < ::TeacherCashIncome
    belongs_to :place
    validates_presence_of :place

    def self.find_or_initialize_by_place_date(place, date, teacher)
      # find_or_initialize_by place: place, date: date, teacher: teacher do |income|
      # end
    end

    def kind_description
      'Seguro sala'
    end
  end
end
