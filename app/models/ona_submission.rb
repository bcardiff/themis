class OnaSubmission < ActiveRecord::Base
  default_scope { order('created_at desc') }

  serialize :data, JSON


  def process!
    begin
      # TODO begin transaction
      if self.form == 'issued_class'
        CourseLog.process self.data
      end
      self.status = 'done'
      self.log = nil
    rescue Exception => e
      self.log = e.to_s
      self.status = 'error'
    end

    self.save!
  end
end
