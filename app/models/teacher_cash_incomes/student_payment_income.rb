module TeacherCashIncomes
  class StudentPaymentIncome < StudentCourseLogIncome
    attr_accessor :payment_plan_on_cashier

    scope :pack_payment, -> { where.not(payment_amount: PaymentPlan.find_by(code: PaymentPlan::SINGLE_CLASS).price) }

    def self.find_or_initialize_by_student_course_log(student_course_log)
      # find_or_initialize_by student_course_log: student_course_log do |income|
      # end
    end

    def self.create_cashier_pack_payment!(teacher, student, date, payment_plan)
      create!(teacher: teacher, date: date, student: student, payment_plan_on_cashier: payment_plan,
              payment_amount: payment_plan.price).tap do |income|
        ActivityLogs::Student::Payment.record_cashier_pack_payment(student, income, payment_plan)
      end
    end

    def kind_description
      'Pago de alumno'
    end

    before_save do
      place = student_course_log.try { |scl| scl.course_log.course.place }
      place.after_payment(self) if place
    end

    before_destroy do
      place = student_course_log.try { |scl| scl.course_log.course.place }
      place.after_payment_destroy(self) if place
    end

    after_save :update_student_packs
    after_destroy :update_student_packs

    def update_student_packs
      StudentPack.recalculate(self)
    end
  end
end
