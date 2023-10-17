class OnaSubmission < ActiveRecord::Base
  default_scope { order('created_at desc') }

  serialize :data, JSON
  has_many :ona_submission_subscriptions

  scope :with_error, -> { where(status: 'error') }
  scope :with_dismissed_errors, -> { where(status: 'dismiss') }

  def can_yank?
    status == 'done' # && ... payments were not transfered ...
  end

  def can_dismiss?
    status == 'error' || status == 'yanked'
  end

  def can_edit?
    status == 'error' || status == 'yanked'
  end

  def dismiss!
    self.status = 'dismiss'
    save!
  end

  def process!(raise: false)
    begin
      CourseLog.transaction(requires_new: true) do
        raise "unable to process '#{form}' form" unless form == 'issued_class'

        CourseLog.process data, self

        self.status = 'done'
        self.log = nil
      end
    rescue StandardError => e
      raise e if raise

      self.log = "#{e}\n#{e.backtrace.join("\n")}"
      self.status = 'error'
    end
    auto_follow

    save!
  end

  def yank!
    begin
      CourseLog.transaction(requires_new: true) do
        raise "unable to yank '#{form}' form" unless form == 'issued_class'

        CourseLog.yank data, self

        self.log = nil
        self.status = 'yanked'
      end
    rescue StandardError => e
      self.log = "#{e}\n#{e.backtrace.join("\n")}"
      save!
      raise e
    end

    save!
  end

  def auto_follow
    return unless form == 'issued_class'

    teacher_name = data['teacher']
    teacher = Teacher.find_by(name: teacher_name)
    OnaSubmissionSubscription.find_or_create_by(ona_submission: self, follower: teacher) if teacher

    teacher_name = data['secondary_teacher']
    teacher = Teacher.find_by(name: teacher_name)
    OnaSubmissionSubscription.find_or_create_by(ona_submission: self, follower: teacher) if teacher

    course_code = data['course']
    course = Course.find_by(code: course_code)
    return unless course

    place = course.place
    return unless place

    OnaSubmissionSubscription.find_or_create_by(ona_submission: self, follower: place)
  end

  def edit_data_url(ona_api)
    ona_api.submission_edit_url(data)
  end

  def pull_from_ona!(ona_api)
    self.data = ona_api.submission_updated_data(data)
    save!
  end

  def ona_data_url
    'https://ona.io/api/v1/data/22845/4503'
  end
end
