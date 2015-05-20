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

  # def teach
  #   logger.info "POST ONA TEACH: #{@submission.data}"

  #   # teachers come in space separated values
  #   @submission.data['teacher'].split.each do |teacher_name|
  #     TeachLog.create date: @submission.data['today'],
  #       teacher: Teacher.find_by(name: teacher_name),
  #       course: Course.find_by(code: @submission.data['course'])
  #   end
  #   @submission.status = 'done'
  #   @submission.save!
  #   head :ok
  # end

  private

  def parse_data
    data = JSON.parse(request.raw_post)
    @submission = OnaSubmission.create form: params[:action], data: data, status: 'pending'
  end

end
