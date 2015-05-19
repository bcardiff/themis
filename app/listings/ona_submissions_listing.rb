class OnaSubmissionsListing < Listings::Base
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
    link_to 'reprocesar', reprocess_admin_ona_submission_path(id: s.id), method: :post
  end
end
