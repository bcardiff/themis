class AdminOnaSubmissionsListing < Listings::Base
  model OnaSubmission

  column :created_at
  column :form
  column :data do |s|
    text_modal('ver', 'Raw Data', JSON.pretty_generate(s.data))
  end
  column :status do |s|
    if s.status != 'done'
      h(s.status) + h(' ') + text_modal('...', 'Error Log', s.log)
    else
      h(s.status)
    end
  end

  column '' do |s|
    render partial: 'shared/ona_submission_actions', locals: {s: s}
  end
end
