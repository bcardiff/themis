RSpec.shared_context 'swc context' do
  let!(:hq) { Place.default }
  let!(:mariel) { create :teacher, name: 'Mariel' }
  let!(:manuel) { create :teacher, name: 'Manuel' }

  let!(:cajero) { create :cashier_user }

  let(:lh_int1_description) { 'Lindy Hop - Intermedios 1' }
  let!(:lh_int1) { create :track, code: 'LH_INT1', name: lh_int1_description }
  let!(:lh_int1_today) { create :course, track: lh_int1, code: 'LH_INT1_TODAY', weekday: School.today.wday }

  let(:lh_int2_description) { 'Lindy Hop - Intermedios 2' }
  let!(:lh_int2) { create :track, code: 'LH_INT2', name: lh_int2_description }
  let!(:lh_int2_yesterday) { create :course, track: lh_int2, code: 'LH_INT2_yesterday', weekday: School.today.wday - 1 }

  let!(:john_doe) { create :student, first_name: 'John', last_name: 'Doe' }
  let!(:jane_doe) { create :student, first_name: 'Jane', last_name: 'Doe' }

  let(:single_class_price) { 100 }
  let!(:single_class) do
    create :payment_plan, code: PaymentPlan::SINGLE_CLASS, description: "Clase suelta $#{single_class_price}",
                          price: single_class_price, weekly_classes: 1
  end

  def signin_as_room
    goto_page RoomLogin do |page|
      page.password.set Settings.room_password
      page.submit.click
    end
  end
end
