# Preview all emails at http://localhost:3000/rails/mailers/student_notifications
class StudentNotificationsPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/student_notifications/welcome
  def welcome
    StudentNotifications.welcome(Student.first)
  end

  # Preview this email at http://localhost:3000/rails/mailers/student_notifications/pack_granted
  def pack_granted
    StudentNotifications.pack_granted(Student.first, PaymentPlan.find_by(code: "1_X_SEMANA_4"))
  end

end
