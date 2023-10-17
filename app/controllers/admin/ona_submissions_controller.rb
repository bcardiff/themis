class Admin::OnaSubmissionsController < Admin::BaseController
  before_action do
    @ona_api = Ona::Api.new(Settings.ona_api_token)
  end

  def index; end

  def reprocess
    OnaSubmission.find(params[:id]).process!
    # TODO: alert
    redirect_to :admin_ona_submissions
  end

  def dismiss
    OnaSubmission.find(params[:id]).dismiss!
    # TODO: alert
    redirect_to :admin_ona_submissions
  end

  def yank
    OnaSubmission.find(params[:id]).yank!
    # TODO: alert
    redirect_to :admin_ona_submissions
  end

  def pull_from_ona
    s = OnaSubmission.find(params[:id])
    s.pull_from_ona!(@ona_api)
    s.process!
    redirect_to :admin_ona_submissions
  end

  def ona_edit
    s = OnaSubmission.find(params[:id])
    redirect_to s.edit_data_url(@ona_api)
  end

  def api_forward
    url = params[:path]
    url += ".#{params[:format]}" unless params[:format].blank?
    url += "?#{request.query_string}" unless request.query_string.blank?
    render json: @ona_api.get_json(url)
  end

  def missing_forms; end
end
