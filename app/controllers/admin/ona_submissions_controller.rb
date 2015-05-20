class Admin::OnaSubmissionsController < Admin::BaseController
  def index
  end

  def reprocess
    OnaSubmission.find(params[:id]).process!
    # TODO alert
    redirect_to :admin_ona_submissions
  end

  def dismiss
    OnaSubmission.find(params[:id]).dismiss!
    # TODO alert
    redirect_to :admin_ona_submissions
  end
end
