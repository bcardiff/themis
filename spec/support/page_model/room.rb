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

class RoomStudentPicker < SitePrism::Page
  set_url "/room/course_log/{id}/students"

  def type_card(card_code)
    if md = /\d+/.match(card_code)
      card = md[0].to_s
    else
      raise "Invalid card #{card_code}"
    end

    card.each_char do |c|
      click_button c
    end

    self.wait_for_ajax
  end

  def submit_card
    click_button "Dar Presente"
    self.wait_for_ajax
  end
end
