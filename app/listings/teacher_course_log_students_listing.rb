class TeacherCourseLogStudentsListing < Listings::Base
  model do
    @course_log = CourseLog.find(params[:course_log_id] || params[:id])
    @course_log.students
  end

  def find_student_log(student)
    @course_log.student_course_logs.where(student: student).first
  end

  column 'id_kind' do |student|
    student_log = find_student_log(student)
    student_log.id_kind
  end

  column :card_code, searchable: true
  column :first_name, searchable: true
  column :last_name, searchable: true
  column 'Pago' do |student|
    incomes = find_student_log(student).incomes

    payment_amount = incomes.where('type <> "TeacherCashIncomes::PlaceCommissionExpense"').sum(:payment_amount)

    if payment_amount > 0
      res = number_to_currency payment_amount
    end

    if course_log.course.place.try :has_commission?
      school_incomes = incomes.sum(:payment_amount)
      place_expenses = -incomes.where(type: 'TeacherCashIncomes::PlaceCommissionExpense').sum(:payment_amount)
      if school_incomes > 0 || place_expenses > 0
        res = "#{res} (#{number_to_currency school_incomes} / #{number_to_currency place_expenses})"
      end
    end

    res
  end

  column 'Tipo' do |student|
    student_log = find_student_log(student)
    student_log.payment_plan.try :code
  end

  column '' do |student|
    render partial: 'shared/student_course_log_actions', locals: {student: student, student_course_log: find_student_log(student) }
  end

  export :csv, :xls

end
