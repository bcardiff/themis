class StudentNotifications < ApplicationMailer

  def welcome(student)
    @student = student
    mail to: @student.email, subject: "Bienvenido a #{School.description}"
  end
end
