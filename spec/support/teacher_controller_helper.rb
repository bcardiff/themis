module TeacherControllerHelper
  extend ActiveSupport::Concern

  included do
    before(:each) do
      sign_in(create(:teacher_user))
    end
  end
end
