class RoomLogin < SitePrism::Page
  set_url '/room/sign_in'

  element :password, 'input[name=secret]'
  element :submit, 'input[name=commit]'
end

class RoomCoursePicker < SitePrism::Page
  set_url '/room/choose_course/{place_id}'

  def select_course(text)
    within '#course_list' do
      click_link text
    end
  end
end

class RoomTeacherPicker < SitePrism::Page
  set_url '/room/course_log/{id}/teachers'

  element :submit, '#footer .btn-default'

  def select_teacher(text)
    within '#teachers_form' do
      label = find('label', text: text)
      label.click
    end
  end
end

class RoomStudentPicker < SitePrism::Page
  class StudentsList < SitePrism::Section
    def student_button(name)
      within root_element do
        return first('button', text: name)
      end
    end
  end

  set_url '/room/course_log/{id}/students'

  element :total_students, '.btn.btn-light.students-list-bottom-btn'
  section :students_list, StudentsList, '.students-list'

  def type_card(card_code)
    raise "Invalid card #{card_code}" unless (md = /\d+/.match(card_code))

    card = md[0].to_s

    card.each_char do |c|
      click_button c
    end

    wait_for_ajax
  end

  def open_students_list
    total_students.click
    wait_for_students_list
  end

  def submit_card
    click_button 'Dar Presente'
    wait_for_ajax
  end

  def remove_attendance
    click_button 'Quitar Presente'
    wait_for_ajax
  end
end
