class OnaSubmission < ActiveRecord::Base
  default_scope { order('created_at desc') }

  serialize :data, JSON


  def process!(_raise = false)
    begin
      # TODO begin transaction
      if self.form == 'issued_class'
        CourseLog.process self.data
      else
        raise "unable to process '#{self.form}' form"
      end
      self.status = 'done'
      self.log = nil
    rescue Exception => e
      raise e if _raise
      self.log = e.to_s
      self.status = 'error'
    end

    self.save!
  end
end
