class WelcomeController < ApplicationController
  def index
    if current_user && current_user.admin?
      redirect_to admin_index_url
    end
  end

  def forbidden
  end
end
