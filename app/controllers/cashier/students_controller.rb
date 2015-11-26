class Cashier::StudentsController < Cashier::BaseController
  expose(:student)

  def index
    respond_to do |format|
      format.html
      format.json do
        students = Student.autocomplete(params[:q]).page(params[:page]).per(5)

        render json: {
          total_count: students.total_count,
          items: students.map { |s| student_json(s) },
          next_url: students.last_page? ? nil : cashier_students_path(format: :json, q: params[:q], page: students.next_page)
        }
      end
    end
  end

  def show
    render 'admin/students/show'
  end

  private

  def student_json(student)
    {
      id: student.id,
      card_code: student.card_code,
      first_name: student.first_name,
      last_name: student.last_name,
    }
  end
end
