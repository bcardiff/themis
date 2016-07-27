require 'rails_helper'

describe "room page" do
  it "can be accessed from home page using code" do
    goto_page Home do |page|
      page.room_link.click
    end

    expect_page RoomLogin do |page|
      page.password.set Settings.room_password
      page.submit.click
    end

    expect_page RoomCoursePicker do |page|
      expect(page.text).to match /Apertura de clase/i
    end
  end
end
