class TeachersController < ApplicationController
  def index
  end

  def teach_log
    @teach_logs = Teacher.find(params[:id]).teach_logs
  end
end
