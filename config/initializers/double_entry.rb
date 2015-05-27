require 'double_entry'

DoubleEntry.configure do |config|
  config.define_accounts do |accounts|
    teacher_scope = accounts.active_record_scope_identifier(Teacher)
    accounts.define(:identifier => :student_payments, :scope_identifier => teacher_scope, :positive_only => true)

    student_scope = accounts.active_record_scope_identifier(Student)
    accounts.define(:identifier => :student_account, :scope_identifier => student_scope)

    accounts.define(:identifier => :course_income, :positive_only => true)
  end

  config.define_transfers do |transfers|
    transfers.define(:from => :student_payments, :to => :course_income, :code => :deliver_student_payment)
    transfers.define(:from => :student_account, :to => :student_payments, :code => :course_payment)

    # transfers.define(:from => :savings,  :to => :checking, :code => :withdraw)
  end
end
