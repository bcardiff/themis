class Admin::UsersController < Admin::BaseController
  expose(:user, attributes: :user_params)

  def index; end

  def show; end

  def update
    user.save!
    redirect_to :admin_users
  end

  def become
    sign_in(:user, user)
    redirect_to root_url
  end

  private

  def user_params
    params.require(:user).permit(:admin, :teacher_id, :place_id)
  end
end
