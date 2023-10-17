module TeacherCashIncomes
  class VenueRent < ::TeacherCashIncome
    validates_presence_of :description
    validates_presence_of :payment_amount

    def self.create_venue_rent_payment!(teacher, date, payment_amount, description)
      create!(teacher: teacher, date: date, payment_amount: - payment_amount, description: description)
    end

    def kind_description
      'Alquiler de sala'
    end
  end
end
