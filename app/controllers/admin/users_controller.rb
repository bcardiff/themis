class Admin::UsersController < Admin::BaseController
  expose(:user, attributes: :user_params)

  def index
  end

  def show
  end

  def update
    user.save!
    redirect_to :admin_users
  end

  private

  def user_params
    params.require(:user).permit(:admin, :teacher_id)
  end
end
