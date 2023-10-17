require 'rails_helper'

describe 'room page' do
  include_context 'swc context'

  it 'can be accessed from home page using code' do
    goto_page Home do |page|
      page.room_link.click
    end

    expect_page RoomLogin do |page|
      page.password.set Settings.room_password
      page.submit.click
    end

    expect_page RoomCoursePicker do |page|
      expect(page.text).to match(/Apertura de clase/i)
    end
  end

  it 'shows todays course' do
    signin_as_room

    expect_page RoomCoursePicker do |page|
      expect(page.text).to match lh_int1_description
      expect(page.text).to_not match lh_int2_description

      page.select_course lh_int1_description
    end
  end

  it 'creates course_log with selected teacher' do
    expect(CourseLog.count).to eq 0

    signin_as_room

    expect_page RoomCoursePicker do |page|
      page.select_course lh_int1_description
    end

    expect_page RoomTeacherPicker do |page|
      page.select_teacher mariel.name
      page.submit.click
    end

    expect(CourseLog.count).to eq 1
    course_log = CourseLog.first
    expect(course_log.teachers).to eq [mariel]
    expect(course_log.course).to eq lh_int1_today
    expect(course_log.students).to be_empty
  end

  context 'on a class given by a teacher' do
    before(:each) do
      signin_as_room

      expect_page RoomCoursePicker do |page|
        page.select_course lh_int1_description
      end

      expect_page RoomTeacherPicker do |page|
        page.select_teacher mariel.name
        page.submit.click
      end
    end

    context 'a student without balance go to class' do
      before(:each) do
        expect_page RoomStudentPicker do |page|
          page.type_card john_doe.card_code
          page.submit_card
        end

        john_doe.reload
      end

      it 'should have a course_log' do
        expect(john_doe.student_course_logs.count).to eq 1
      end

      it 'should have a debt' do
        expect(john_doe.student_course_logs.first.missing_payment?).to eq true
      end

      context 'but then it is removed' do
        before(:each) do
          expect_page RoomStudentPicker do |page|
            page.open_students_list
            page.students_list.student_button(john_doe.display_name).click
            page.remove_attendance
          end

          john_doe.reload
        end

        it 'should not have a course_log' do
          expect(john_doe.student_course_logs.count).to eq 0
        end
      end
    end
  end
end
