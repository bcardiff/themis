class OnaSubmission < ActiveRecord::Base
  default_scope { order('created_at desc') }

  serialize :data, JSON

  scope :with_error, -> { where(status: 'error') }

  def can_dismiss?
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

    self.save!
  end
end
