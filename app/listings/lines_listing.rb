class LinesListing < Listings::Base
  model { DoubleEntry::Line.where("amount < 0").order(created_at: :desc) }

  column :code do |line|
    case line.code
    when :course_payment
      'Pago en clase'
    when :deliver_student_payment
      'Entrega de pago'
    end
  end

  column :account do |line|
    account_link line.account
  end
  column :partner_account do |line|
    account_link line.partner_account
  end

  column :amount do |line|
    number_to_currency -line.amount
  end

  column :created_at


  export :csv, :xls

  def account_link(account)
    case account.identifier
    when :student_account
      "Alumno: #{Student.find(account.scope).display_name}"
    when :student_payments
      "Pago de alumnos: #{Teacher.find(account.scope).name}"
    when :course_income
      "Ingresos por clases"
    else
      raise "unkown account #{account.identifier}"
    end
  end

end
