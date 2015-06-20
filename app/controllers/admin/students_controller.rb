class Admin::StudentsController < Admin::BaseController
  expose(:student, attributes: :student_params)

  def index
  end

  def show
  end

  def edit
  end

  def update
    student.save!
    redirect_to admin_student_path(student)
  end

  private

  def student_params
    params.require(:student).permit(:first_name, :last_name, :email, :card_code)
  end
end
