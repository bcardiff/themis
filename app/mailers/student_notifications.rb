class StudentNotifications < ApplicationMailer
  def welcome(student)
    @student = student
    mail to: @student.email, subject: subjects[:welcome], template_path: default_template_path
  end

  def pack_granted(student_pack)
    @student_pack = student_pack
    @student = @student_pack.student
    @receipt = @student_pack.receipt
    mail to: @student_pack.student.email, subject: subjects[:pack_granted], template_path: default_template_path
  end

  private

  def default_template_path
    ["student_notifications/#{Settings.branch}", 'student_notifications']
  end

  def subjects
    case Settings.branch
    when 'sheffield'
      {
        welcome: "Welcome to #{School.description}!! - IMPORTANT INFORMATION",
        pack_granted: "#{School.description} - Pack confirmation"
      }
    else
      {
        welcome: "¡¡Te damos la bienvenida a #{School.description}!! - INFORMACIÓN IMPORTANTE",
        pack_granted: "#{School.description} - Confirmación Pack de clases"
      }
    end
  end
end
