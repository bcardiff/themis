class AdminUsersListing < Listings::Base
  model User

  column :email, searchable: true do |user|
    mail_to user.email
  end

  column :admin do |user|
    user.admin? ? '✓' : ''
  end

  column 'teacher' do |user|
    user.teacher.try :name
  end

  column 'place' do |user|
    user.place.try :name
  end

  column '' do |user|
    link_to 'editar', admin_user_path(user)
  end

  column '' do |user|
    link_to 'login', become_admin_user_path(user)
  end
end
