class WelcomeController < ApplicationController
  def index
    redirect_to admin_index_url
  end
end
