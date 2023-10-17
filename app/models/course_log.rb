class CourseLog < ActiveRecord::Base
  belongs_to :course
  validates_presence_of :course, :date
  validate :validate_course_date

  has_many :teacher_course_logs, dependent: :destroy
  has_many :teachers, through: :teacher_course_logs

  has_many :student_course_logs
  has_many :students, through: :student_course_logs

  def incomes
    TeacherCashIncome.where(course_log_id: id)
  end

  scope :missing, -> { where(missing: true) }
  scope :cashier_attention_required_untracked, lambda {
    where('untracked_students_count > 0')
  }
  scope :cashier_attention_required_missing_payment, lambda {
    includes(:student_course_logs).where(student_course_logs: { requires_student_pack: true, student_pack: nil })
  }
  scope :at_place, lambda { |place|
    includes(:course).where(courses: { place_id: place.id })
  }

  def students_count
    student_course_logs.count + untracked_students_count
  end

  def validate_course_date
    return unless date && date.wday != course.weekday

    errors.add(:date,
               "invalid date for course #{date} is #{Date::DAYNAMES[date.wday]} but not #{Date::DAYNAMES[course.weekday]}")
  end

  def self.fill_missings
    today = School.today

    Course.joins('LEFT JOIN course_logs ON course_logs.course_id = courses.id')
      .select('courses.*, max(course_logs.date) as last')
      .group('courses.id').each do |course|
      # avoid going to much into the past if there is no last course
      # useful for fresh dev environments
      next_date = (course.last || [course.valid_since - 1.day, School.today - 2.month].max).next_wday(course.weekday)

      while next_date < today && (course.valid_until.nil? || next_date < course.valid_until)
        for_course_on_date(course.code, next_date) do |course_log|
          course_log.missing = true
        end

        next_date += 1.week
      end
    end
  end

  def self.process(data, ona_submission)
    for_course_on_date(data['course'], data['date']) do |course_log|
      teacher = course_log.add_teacher(data['teacher'])

      course_log.add_teacher(data['secondary_teacher'])

      (data['student_repeat'] || []).each_with_index do |student_payload, index|
        StudentCourseLog.process(course_log, teacher, student_payload, ona_submission, "student_repeat[#{index}]")
      end

      course_log.course.place.after_class(course_log.date, teacher) if course_log.course.place
    end
  end

  def self.yank(data, ona_submission)
    for_course_on_date(data['course'], data['date']) do |course_log|
      (data['student_repeat'] || []).each_with_index do |student_payload, index|
        StudentCourseLog.yank(course_log, student_payload, ona_submission, "student_repeat[#{index}]")
      end

      if course_log.students.count.zero?
        course_log.teacher_course_logs.each(&:destroy!)

        course_log.missing = true

        course_log.course.place.after_class_yank(course_log.date) if course_log.course.place
      end
    end
  end

  def self.for_course_on_date(course_code, date)
    course = Course.find_by!(code: course_code)
    date = Date.parse(date) unless date.is_a? Date

    course_log = CourseLog.find_or_initialize_by(course: course, date: date)
    course_log.missing = false

    yield course_log if block_given?

    course_log.save!

    course_log
  end

  def add_teacher(teacher_name)
    return nil if teacher_name.blank?

    teacher = Teacher.find_by!(name: teacher_name)
    teacher_log = teacher_course_logs.first_or_build(teacher: teacher)
    if teacher_log.new_record?
      teacher_log.paid = false
      teacher_log.paid_amount = nil
      teacher_log.paid_at = nil
    end

    teacher_log.save!

    teacher
  end

  def status
    missing ? 'Sin información enviada' : 'Ok'
  end

  def suggested_teacher
    teachers.select { |t| t.teacher_cash_incomes.where(course_log_id: id).count > 0 }.first ||
      teachers.first
  end

  def course_kind
    course.track.course_kind
  end
end
