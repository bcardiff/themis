class Admin::StudentsController < Admin::BaseController
  expose(:student, attributes: :student_params)

  def update
    if student.save
      redirect_to admin_student_path(student)
    else
      render :edit
    end
  end

  def create
    if student.save
      redirect_to [:admin, student]
    else
      render :new
    end
  end

  private

  def student_params
    params.require(:student).permit(:first_name, :last_name, :email, :card_code)
  end
end
