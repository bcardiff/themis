class AdvanceStudentPackAction < Action::Base
  def initialize(current_user, student_pack)
    super
    @current_user = current_user
    @student_pack = student_pack
  end

  def can?
    @current_user.admin? || @current_user.cashier?
  end

  def perform
    delta = 1.month
    @student_pack.start_date = @student_pack.start_date - delta
    @student_pack.due_date = (@student_pack.due_date - delta).at_end_of_month
    @student_pack.save!
  end
end
