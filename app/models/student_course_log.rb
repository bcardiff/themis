class StudentCourseLog < ActiveRecord::Base
  belongs_to :student
  belongs_to :course_log
  belongs_to :teacher
  serialize :payload, JSON

  validates_presence_of :student, :course_log
  validate :validate_teacher_in_course_log

  def validate_teacher_in_course_log
    return unless teacher && course_log

    errors.add(:teacher, 'must be in the course_log') unless course_log.teachers.include?(teacher)
  end

  def self.process(course_log, teacher, payload)
    id_kind = payload["student_repeat/id_kind"]
    card = payload["student_repeat/card"]
    email = payload["student_repeat/email"]
    name = payload["student_repeat/name"]

    case id_kind
    when "new_card"
      # TODO when reprocessing this will leads to an error
      student = Student.find_or_initialize_by card_code: card
      if student.new_record?
        student.first_name = name
        student.email = email
        student.save!
      end
    when "existing_card"
      return if card.blank?
      student = Student.find_by card_code: card
    when "guest"
      student = Student.find_or_initialize_by email: email
      if student.new_record?
        student.card_code = nil
        student.first_name = name
      end
    else
      raise 'not supported id_kind'
    end

    student_log = course_log.student_course_logs.first_or_build(student: student)
    student_log.payload = payload.to_json
    student_log.teacher = teacher
    student_log.save!
  end
end
