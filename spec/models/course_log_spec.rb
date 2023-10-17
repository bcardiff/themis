require 'rails_helper'

RSpec.describe CourseLog, type: :model do
  let!(:plan_clase) { create(:payment_plan, code: PaymentPlan::SINGLE_CLASS, price: 70, weekly_classes: 1) }

  it 'factory works' do
    create(:course_log)
  end

  it 'validates presence of date' do
    c = build(:course_log, date: nil)
    expect(c.valid?).to be_falsey
  end

  it 'validates presence of course' do
    c = build(:course_log, course: nil)
    expect(c.valid?).to be_falsey
  end

  describe 'fill_missings' do
    let!(:course) { create(:course, weekday: 2, valid_since: Date.new(2015, 5, 1), valid_until: Date.new(2015, 5, 31)) }

    context 'empty history' do
      before(:each) do
        allow(School).to receive(:today).and_return(today)
        CourseLog.fill_missings
      end

      context 'one day after the course' do
        let(:today) { Date.new(2015, 5, 6) }

        it 'should create as missing' do
          expect(CourseLog.all.count).to eq(1)
          log = CourseLog.all.first

          expect(log.course).to eq(course)
          expect(log.date).to eq(today - 1.day)
          expect(log.missing).to be_truthy
        end
      end

      context 'multiple weeks' do
        let(:today) { Date.new(2015, 5, 20) }

        it 'should create as missing' do
          expect(CourseLog.all.count).to eq(3)

          expect(CourseLog.all.map(&:date)).to eq([Date.new(2015, 5, 5), Date.new(2015, 5, 12), Date.new(2015, 5, 19)])
          expect(CourseLog.all.map(&:missing)).to eq([true, true, true])
        end
      end

      context 'after the course has ended' do
        let(:today) { Date.new(2015, 6, 20) }

        it 'should create as missing' do
          expect(CourseLog.all.count).to eq(4)
        end
      end
    end

    context 'with history' do
      before(:each) do
        CourseLog.for_course_on_date(course.code, '2015-05-12')
        allow(School).to receive(:today).and_return(today)
        CourseLog.fill_missings
      end

      context 'on the same day of the course' do
        let(:today) { Date.new(2015, 5, 19) }

        it 'should create as missing' do
          expect(CourseLog.missing.count).to eq(0)
        end
      end

      context 'one day after the course' do
        let(:today) { Date.new(2015, 5, 27) }

        it 'should create as missing' do
          expect(CourseLog.missing.count).to eq(2)
          expect(CourseLog.missing.map(&:date)).to eq([Date.new(2015, 5, 19), Date.new(2015, 5, 26)])
        end
      end
    end
  end

  describe 'for_course_on_date' do
    let(:course) { create(:course, weekday: 5) }
    let(:course_code) { course.code }

    it 'should create new course_log' do
      c = nil

      expect do
        c = CourseLog.for_course_on_date(course_code, '2015-05-15')
      end.to change { CourseLog.count }.by(1)

      expect(c.course).to eq(course)
      expect(c.date).to eq(Date.new(2015, 5, 15))
    end

    it 'should only one course_log per course, date' do
      c = CourseLog.for_course_on_date(course_code, '2015-05-15')
      c1 = nil

      expect do
        c1 = CourseLog.for_course_on_date(course_code, '2015-05-15')
      end.to change { CourseLog.count }.by(0)

      expect(c1).to eq(c)
    end
  end

  describe 'teacher_course_logs' do
    let(:teacher) { create(:teacher) }
    let(:onther_teacher) { create(:teacher) }
    let(:course) { create(:course, weekday: 2) }
    let(:course_log) { CourseLog.for_course_on_date(course.code, '2015-05-19') }

    it 'should add teacher only' do
      expect do
        course_log.add_teacher teacher.name
      end.to change { TeacherCourseLog.count }.by(1)
    end

    it 'should add teacher only once' do
      course_log.add_teacher teacher.name

      expect do
        course_log.add_teacher teacher.name
      end.to change { TeacherCourseLog.count }.by(0)
    end

    it 'should add many teacher only once' do
      expect do
        course_log.add_teacher teacher.name
        course_log.add_teacher onther_teacher.name
      end.to change { TeacherCourseLog.count }.by(2)
    end

    it 'should raise if invalid teacher' do
      expect do
        course_log.add_teacher 'invalid'
      end.to raise_error
    end
  end

  describe 'students' do
    it 'should count students' do
      expect(create(:course_log).students_count).to eq(0)
    end
  end

  describe 'yank ona submission' do
    let(:caballito) { create(:place, name: Place::CABALLITO) }
    let(:caballito_course) { create(:course, weekday: 4, place: caballito) }
    let(:other_course) { create(:course, weekday: 4) }
    let(:teacher) { create(:teacher) }
    let(:plan) { create(:payment_plan, weekly_classes: 1) }

    context 'yanking all student_course_logs' do
      context 'with new students without further activities' do
        before(:each) do
          @submission = submit_student({
                                         'student_repeat/id_kind' => 'new_card',
                                         'student_repeat/card' => '465',
                                         'student_repeat/email' => 'johndoe@email.com',
                                         'student_repeat/first_name' => 'John',
                                         'student_repeat/last_name' => 'Doe',
                                         'student_repeat/do_payment' => 'yes',
                                         'student_repeat/payment/kind' => plan.code
                                       })

          submission.yank!
        end

        let(:submission) { OnaSubmission.find(@submission.id) }
        let(:course_log) { CourseLog.first }

        it 'should leave submission as yanked' do
          expect(submission.status).to eq('yanked')
        end

        it 'should delete student' do
          expect(Student.count).to eq(0)
        end

        it 'should delete student_course_log' do
          expect(StudentCourseLog.count).to eq(0)
        end

        it 'should leave course_log as missing' do
          expect(course_log.missing).to be_truthy
        end

        it 'should leave no teachers in course_log' do
          expect(course_log.teachers.count).to eq(0)
        end

        it 'should leave place expenses in zero' do
          expect(caballito.expenses.count).to eq(0)
        end

        it 'should leave no logs' do
          expect(ActivityLog.count).to eq(0)
        end
      end

      context 'with new students with further activities' do
        before(:each) do
          @submission = submit_student({
                                         'student_repeat/id_kind' => 'new_card',
                                         'student_repeat/card' => '465',
                                         'student_repeat/email' => 'johndoe@email.com',
                                         'student_repeat/first_name' => 'John',
                                         'student_repeat/last_name' => 'Doe',
                                         'student_repeat/do_payment' => 'yes',
                                         'student_repeat/payment/kind' => plan.code
                                       })

          submit_student(other_course, {
                           'student_repeat/id_kind' => 'existing_card',
                           'student_repeat/card' => '465',
                           'student_repeat/do_payment' => 'no'
                         })
        end

        let(:submission) { OnaSubmission.find(@submission.id) }
        let(:course_log) { CourseLog.first }

        it 'should fail' do
          expect do
            submission.yank!
          end.to raise_error
        end

        # it "should leave submission as yanked"
        # it "should not delete student"
        # it "should leave course_log as missing"
        # it "should leave no teachers in course_log"
        # it "should leave place expenses in zero"
      end

      context 'with new guests without further activities' do
        before(:each) do
          @submission = submit_student({
                                         'student_repeat/id_kind' => 'guest',
                                         'student_repeat/card' => '465',
                                         'student_repeat/email' => 'johndoe@email.com',
                                         'student_repeat/first_name' => 'John',
                                         'student_repeat/last_name' => 'Doe',
                                         'student_repeat/do_payment' => 'yes',
                                         'student_repeat/payment/kind' => plan.code
                                       })

          submission.yank!
        end

        let(:submission) { OnaSubmission.find(@submission.id) }
        let(:course_log) { CourseLog.first }

        it 'should leave submission as yanked' do
          expect(submission.status).to eq('yanked')
        end

        it 'should delete student' do
          expect(Student.count).to eq(0)
        end

        it 'should delete student_course_log' do
          expect(StudentCourseLog.count).to eq(0)
        end

        it 'should leave course_log as missing' do
          expect(course_log.missing).to be_truthy
        end

        it 'should leave no teachers in course_log' do
          expect(course_log.teachers.count).to eq(0)
        end

        it 'should leave place expenses in zero' do
          expect(caballito.expenses.count).to eq(0)
        end
      end

      context 'with new guests with further activities' do
        before(:each) do
          @submission = submit_student({
                                         'student_repeat/id_kind' => 'guest',
                                         'student_repeat/email' => 'johndoe@email.com',
                                         'student_repeat/first_name' => 'John',
                                         'student_repeat/last_name' => 'Doe',
                                         'student_repeat/do_payment' => 'yes',
                                         'student_repeat/payment/kind' => plan.code
                                       })

          submit_student(other_course, {
                           'student_repeat/id_kind' => 'guest',
                           'student_repeat/email' => 'johndoe@email.com',
                           'student_repeat/first_name' => 'John',
                           'student_repeat/last_name' => 'Doe',
                           'student_repeat/do_payment' => 'no'
                         })

          submission.yank!
        end

        let(:submission) { OnaSubmission.find(@submission.id) }
        let(:course_log) { CourseLog.first }

        it 'should leave submission as yanked' do
          expect(submission.status).to eq('yanked')
        end

        it 'should not delete student' do
          expect(Student.count).to eq(1)
        end

        it 'should leave course_log as missing' do
          expect(course_log.missing).to be_truthy
        end

        it 'should leave no teachers in course_log' do
          expect(course_log.teachers.count).to eq(0)
        end

        it 'should leave place expenses in zero' do
          expect(caballito.expenses.count).to eq(0)
        end
      end

      context 'with existing student' do
        before(:each) do
          @submission = submit_student({
                                         'student_repeat/id_kind' => 'existing_card',
                                         'student_repeat/card' => '465',
                                         'student_repeat/do_payment' => 'yes',
                                         'student_repeat/payment/kind' => plan.code
                                       })

          submit_student(other_course, {
                           'student_repeat/id_kind' => 'existing_card',
                           'student_repeat/card' => '465',
                           'student_repeat/do_payment' => 'no'
                         })

          submission.yank!
        end

        let(:submission) { OnaSubmission.find(@submission.id) }
        let(:course_log) { CourseLog.first }

        it 'should leave submission as yanked' do
          expect(submission.status).to eq('yanked')
        end

        it 'should not delete student' do
          expect(Student.count).to eq(1)
        end

        it 'should leave other activies' do
          expect(ActivityLog.count).to eq(1)
        end

        it 'should leave course_log as missing' do
          expect(course_log.missing).to be_truthy
        end

        it 'should leave no teachers in course_log' do
          expect(course_log.teachers.count).to eq(0)
        end

        it 'should leave place expenses in zero' do
          expect(caballito.expenses.count).to eq(0)
        end
      end
    end

    context 'yanking some student_course_logs' do
      before(:each) do
        @submission = submit_student({
                                       'student_repeat/id_kind' => 'existing_card',
                                       'student_repeat/card' => '465',
                                       'student_repeat/do_payment' => 'no'
                                     })

        submit_student({
                         'student_repeat/id_kind' => 'existing_card',
                         'student_repeat/card' => '465',
                         'student_repeat/do_payment' => 'yes',
                         'student_repeat/payment/kind' => plan.code
                       })

        submission.yank!
      end

      let(:submission) { OnaSubmission.find(@submission.id) }
      let(:course_log) { CourseLog.first }

      it 'should leave submission as yanked' do
        expect(submission.status).to eq('yanked')
      end

      it 'should not delete student' do
        expect(Student.count).to eq(1)
      end

      it 'should not leave course_log as missing' do
        expect(course_log.missing).to be_falsey
      end

      it 'should leave teachers in course_log' do
        expect(course_log.teachers.count).to eq(1)
      end

      it 'should not leave place expenses in zero' do
        expect(caballito.expenses.count).to_not eq(0)
      end
    end

    context 'yanking student_course_logs with transferred money' do
      before(:each) do
        @submission = submit_student({
                                       'student_repeat/id_kind' => 'existing_card',
                                       'student_repeat/card' => '465',
                                       'student_repeat/do_payment' => 'yes',
                                       'student_repeat/payment/kind' => plan.code
                                     })

        teacher.transfer_cash_income_money(plan.price, Time.now)
      end

      let(:submission) { OnaSubmission.find(@submission.id) }
      let(:course_log) { CourseLog.first }

      it 'should fail' do
        expect do
          submission.yank!
        end.to raise_error
      end
    end

    def submit_student(*student_payload)
      if student_payload.first.is_a? Course
        course, *student_payload = student_payload
      else
        course = caballito_course
      end

      issued_class({
                     'date' => '2015-05-14',
                     'course' => course.code,
                     'teacher' => teacher.name,
                     'student_repeat' => student_payload
                   })
    end

    def issued_class(payload, _raise = true)
      s = OnaSubmission.create form: 'issued_class', data: payload, status: 'pending'
      result = s.process! _raise

      reload_entities

      s
    end

    def reload_entities
      entities = [teacher, caballito_course, caballito]
      entities.map(&:reload)
    end
  end
end
