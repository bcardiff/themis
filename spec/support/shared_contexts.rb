RSpec.shared_context "swc context" do
  let!(:mariel) { create :teacher, name: "Mariel" }
  let!(:manuel) { create :teacher, name: "Manuel" }

  let!(:lh_int1) { create :track, code: "LH_INT1" }
  let(:lh_int1_description) { "Lindy Hop - Intermedios 1" }
  let!(:lh_int1_today) { create :course, code: "LH_INT1_TODAY", name: "#{lh_int1_description} - Hoy", weekday: Date.today.wday }

  let!(:lh_int2) { create :track, code: "LH_INT2" }
  let(:lh_int2_description) { "Lindy Hop - Intermedios 2" }
  let!(:lh_int2_yesterday) { create :course, code: "LH_INT2_yesterday", name: "#{lh_int2_description} - Ayer", weekday: Date.today.wday - 1 }

  def signin_as_room
    goto_page RoomLogin do |page|
      page.password.set Settings.room_password
      page.submit.click
    end
  end
end
