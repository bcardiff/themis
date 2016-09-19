class StudentNotifications < ApplicationMailer

  def welcome(student)
    @student = student
    mail to: @student.email, subject: "Bienvenido a #{School.description}"
  end

  def pack_granted(student, payment_plan)
    @student = student
    @payment_plan = payment_plan
    mail to: @student.email, subject: "Asignación de pack"
  end
end
