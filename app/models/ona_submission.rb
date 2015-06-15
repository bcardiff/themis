class OnaSubmission < ActiveRecord::Base
  default_scope { order('created_at desc') }

  serialize :data, JSON
  has_many :ona_submission_subscriptions

  scope :with_error, -> { where(status: 'error') }
  scope :with_dismissed_errors, -> { where(status: 'dismiss') }

  def can_dismiss?
    self.status == 'error'
  end

  def can_edit?
    self.status == 'error'
  end

  def dismiss!
    self.status = 'dismiss'
    self.save!
  end

  def process!(_raise = false)
    begin
      CourseLog.transaction(requires_new: true) do
        if self.form == 'issued_class'
          CourseLog.process self.data, self
        else
          raise "unable to process '#{self.form}' form"
        end
        self.status = 'done'
        self.log = nil
      end
    rescue Exception => e
      raise e if _raise
      self.log = "#{e.to_s}\n#{e.backtrace.join("\n")}"
      self.status = 'error'
    end
    self.auto_follow

    self.save!
  end

  def auto_follow
    if self.form == 'issued_class'
      teacher_name = self.data['teacher']
      teacher = Teacher.find_by(name: teacher_name)
      if teacher
        OnaSubmissionSubscription.find_or_create_by(ona_submission: self, follower: teacher)
      end
    end
  end

  def edit_data_url(ona_api)
    ona_api.submission_edit_url(self.data)
  end

  def pull_from_ona!(ona_api)
    self.data = ona_api.submission_updated_data(self.data)
    self.save!
  end

  def ona_data_url
    "https://ona.io/api/v1/data/#{22845}/4503"
  end
end
