# Preview all emails at http://localhost:3000/rails/mailers/student_notifications
class StudentNotificationsPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/student_notifications/welcome
  def welcome
    StudentNotifications.welcome(Student.first)
  end

  # Preview this email at http://localhost:3000/rails/mailers/student_notifications/pack_granted
  def pack_granted
    pack = StudentPack.new({
                             student: Student.first,
                             payment_plan: PaymentPlan.find_by(code: '1_X_SEMANA_4'),
                             start_date: School.today.at_beginning_of_month,
                             due_date: School.today.at_end_of_month,
                             max_courses: 4
                           })
    pack.id = 42

    StudentNotifications.pack_granted(pack)
  end
end
