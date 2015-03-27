class OnaSubmission < ActiveRecord::Base
  serialize :data, JSON
end
