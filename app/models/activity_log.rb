class ActivityLog < ActiveRecord::Base
  belongs_to :target, polymorphic: true
  belongs_to :related, polymorphic: true
end
