class RoomLogin < SitePrism::Page
  set_url "/room/sign_in"

  element :password, "input[name=secret]"
  element :submit, "input[name=commit]"
end

class RoomCoursePicker < SitePrism::Page
  set_url "/room"
end
