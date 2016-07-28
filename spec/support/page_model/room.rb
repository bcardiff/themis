class RoomLogin < SitePrism::Page
  set_url "/room/sign_in"

  element :password, "input[name=secret]"
  element :submit, "input[name=commit]"
end

class RoomCoursePicker < SitePrism::Page
  set_url "/room"

  def select_course(text)
    within "#course_list" do
      click_link text
    end
  end
end

class RoomTeacherPicker < SitePrism::Page
  set_url "/room/course_log/{id}/teachers"

  element :submit, "#footer .btn-default"

  def select_teacher(text)
    within "#teachers_form" do
      label = find('label', text: text)
      label.click
    end
  end
end
