class OnaController < ApplicationController
  skip_before_action :verify_authenticity_token

  def json_post
    submission = JSON.parse(request.raw_post)
    logger.info "POST #{submission}"
    head :ok
  end
end
