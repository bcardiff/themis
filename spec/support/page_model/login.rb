class Login < SitePrism::Page
  set_url '/users/sign_in'

  element :email, '#user_email'
  element :password, '#user_password'

  element :submit, 'input[name=commit]'
end
