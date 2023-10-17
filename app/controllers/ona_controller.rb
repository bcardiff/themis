class OnaController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :parse_data

  def json_post
    logger.info "POST ONA: #{@submission.data}"
    head :ok
  end

  def issued_class
    @submission.process!
    CourseLog.fill_missings
    head :ok
  end

  private

  def parse_data
    data = JSON.parse(request.raw_post)
    @submission = OnaSubmission.create form: params[:action], data: data, status: 'pending'
  end
end
