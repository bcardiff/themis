class AdminOnaSubmissionsListing < Listings::Base
  include ApplicationHelper

  model OnaSubmission

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

  %w[date course teacher _id].each do |data_field|
    column data_field do |s|
      s.data[data_field]
    end
  end

  column '' do |s|
    render partial: 'shared/ona_submission_actions', locals: { s: s }
  end
end
