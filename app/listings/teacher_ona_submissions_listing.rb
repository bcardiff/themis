class TeacherOnaSubmissionsListing < Listings::Base
  include ApplicationHelper

  model { current_user.teacher.ona_submissions }

  scope :all, default: true
  scope :with_error, 'Con errors'
  scope :with_dismissed_errors, 'Ignorados'

  column :created_at
  column :form
  column :data do |s|
    text_modal('ver', 'Raw Data', JSON.pretty_generate(s.data))
  end
  column :status do |s|
    if s.status == 'done'
      h(s.status)
    else
      h(s.status) + h(' ') + text_modal('...', 'Error Log', s.log)
    end
  end

  %w[date course teacher].each do |data_field|
    column data_field do |s|
      s.data[data_field]
    end
  end
end
