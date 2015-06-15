class OnaSubmissionSubscription < ActiveRecord::Base
  belongs_to :ona_submission
  belongs_to :follower, polymorphic: true
end
