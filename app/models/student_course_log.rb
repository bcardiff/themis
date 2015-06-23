class StudentCourseLog < ActiveRecord::Base
  PAYMENT_ON_TEACHER = 'teacher'
  PAYMENT_ON_CLASSES_INCOME = 'classes_income'

  belongs_to :student
  belongs_to :course_log
  belongs_to :teacher
  serialize :payload, JSON
  belongs_to :payment_plan
  belongs_to :ona_submission
  def incomes
    # TODO unable to work with has_many and subclasses
    # has_many :incomes, class_name: 'TeacherCashIncomes::StudentCourseLogIncome'
    TeacherCashIncome.where(student_course_log_id: self.id)
  end

  before_validation :clear_payment_if_no_plan
  after_save :record_teacher_cash_income
  after_save :record_student_activities

  validates_presence_of :student, :course_log, :id_kind
  validates :student, uniqueness: { scope: :course_log_id, message: "No puede repetirse el alumno en una clase" }
  validate :validate_teacher_in_course_log
  validate :validate_teacher_if_paying

  scope :with_payment, -> { where.not(payment_status: nil) }

  # TODO on delete, delete teacher income?

  def validate_teacher_in_course_log
    # return unless teacher && course_log
    # errors.add(:teacher, 'must be in the course_log') unless course_log.teachers.include?(teacher)
  end

  def validate_teacher_if_paying
    return unless payment_plan

    errors.add(:teacher, "can't be blank") unless teacher
  end

  def self.process(course_log, teacher, payload, ona_submission, ona_submission_path)
    id_kind = payload["student_repeat/id_kind"]
    card = payload["student_repeat/cardtxt"]
    card = payload["student_repeat/card"] if card.blank?
    email = payload["student_repeat/email"]
    first_name = payload["student_repeat/first_name"]
    last_name = payload["student_repeat/last_name"]
    do_payment = payload["student_repeat/do_payment"]
    payment_kind = payload["student_repeat/payment/kind"]
    payment_amount = payload["student_repeat/payment/amount"]

    # skip empty students
    return if card.blank? and email.blank? and first_name.blank? and payment_kind.blank?

    # if there already was a student course log for this part of the submission
    student = nil
    existing_log = StudentCourseLog.where(ona_submission: ona_submission, ona_submission_path: ona_submission_path).first
    if existing_log
      student = existing_log.student
    end

    case id_kind
    when "new_card"
      student ||= Student.find_or_initialize_by_card card
      student.update_as_new_card!(first_name, last_name, email)
    when "existing_card"
      student ||= Student.find_or_initialize_by_card card
      if student.new_record?
        student.first_name = Student::UNKOWN
        student.last_name = Student::UNKOWN
        student.email = nil
        student.save!
      end
    when "guest"
      student ||= Student.find_or_initialize_by_email email
      student.update_as_guest!(first_name, last_name)
    else
      raise 'not supported id_kind'
    end

    # TODO better error when student is nil
    student_log = existing_log || course_log.student_course_logs.first_or_build(student: student)
    student_log.id_kind = id_kind
    student_log.payload = payload.to_json
    student_log.teacher = teacher
    # keep last ona_submission that affect the student_log
    student_log.ona_submission = ona_submission
    student_log.ona_submission_path = ona_submission_path

    if do_payment == "yes"
      # TODO error handling
      plan = PaymentPlan.find_by!(code: payment_kind)
      student_log.payment_plan = plan
      student_log.payment_amount = plan.price_or_fallback(payment_amount)
    else
      student_log.payment_plan = nil
    end

    student_log.save!
  end

  def self.yank(course_log, payload, ona_submission, ona_submission_path)
    id_kind = payload["student_repeat/id_kind"]
    card = payload["student_repeat/cardtxt"]
    card = payload["student_repeat/card"] if card.blank?
    email = payload["student_repeat/email"]
    first_name = payload["student_repeat/first_name"]
    last_name = payload["student_repeat/last_name"]
    do_payment = payload["student_repeat/do_payment"]
    payment_kind = payload["student_repeat/payment/kind"]
    payment_amount = payload["student_repeat/payment/amount"]

    existing_log = StudentCourseLog.where(ona_submission: ona_submission, ona_submission_path: ona_submission_path).first
    return unless existing_log

    student = existing_log.student

    existing_log.incomes.each { |i| i.destroy! }
    existing_log.destroy!

    case id_kind
    when "new_card"
      student.destroy!
    when "guest"
      if student.student_course_logs.count == 0
        student.destroy!
      end
    when "existing_card"
      # nothing to do
    else
      raise 'not supported id_kind'
    end
  end

  def record_teacher_cash_income
    if id_kind == "new_card"
      income = TeacherCashIncomes::NewCardIncome.find_or_initialize_by_student_course_log(self)
      income.save!
    end

    income = TeacherCashIncomes::StudentPaymentIncome.find_or_initialize_by_student_course_log(self)
    if payment_plan
      # TODO should update only if not transfered TeacherCashIncomes?
      income.payment_amount = payment_plan.price_or_fallback(payment_amount)
      income.save!
    elsif income.persisted?
      income.destroy!
    end
  end

  def record_student_activities
    ActivityLogs::Student::CourseAttended.record(student, course_log)
    if payment_plan
      ActivityLogs::Student::Payment.record(student, self)
    end
  end

  def clear_payment_if_no_plan
    if self.payment_plan.nil?
      self.payment_amount = nil
    end
  end

  def can_edit?(user)
    user.admin?
  end
end
