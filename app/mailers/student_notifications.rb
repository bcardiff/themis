class StudentNotifications < ApplicationMailer

  def welcome(student)
    @student = student
    mail to: @student.email, subject: "¡¡Te damos la bienvenida a !! - INFORMACIÓN IMPORTANTE"
  end

  def pack_granted(student_pack)
    @student_pack = student_pack
    @student = @student_pack.student
    data = <<-RECEIPT
Alumno: #{@student.autocomplete_display_name}
Pack: #{@student_pack.payment_plan.mailer_description}
Vencimiento: #{@student_pack.due_date.to_dmy}
Comprobante: #{student_pack.id}.#{SecureRandom.hex(4)}
RECEIPT
    data = data.strip
    data_to_sign = data.split.join
    sep = "-" * 50
    @receipt = "#{sep}\n#{data}\n#{sep}\nFirma: #{Digest::SHA1.hexdigest(Settings.receipt_secret_key + data_to_sign)}\n#{sep}"
    mail to: @student_pack.student.email, subject: "#{School.description} - Confirmación Pack de clases"
  end
end
