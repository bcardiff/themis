class Room::BaseController < ApplicationController
  layout 'room'
  before_action :check_access, except: [:session_new, :session_create]

  def session_new
    render layout: 'application'
  end

  def session_create
    if params[:secret] == Settings.room_password
      sign_in_as_room!
      redirect_to room_path
    else
      flash.now[:notice] = "Contraseña inválida"
      render 'session_new', layout: 'application'
    end
  end

  protected

  def check_access
    unless is_room_signed?
      redirect_to room_login_path
    end
  end
end
