# Preview all emails at http://localhost:3000/rails/mailers/student_notifications
class StudentNotificationsPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/student_notifications/welcome
  def welcome
    StudentNotifications.welcome(Student.first)
  end

end
