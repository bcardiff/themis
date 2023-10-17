module FeatureSpecHelpers
  def goto_page(klass, args = {})
    page = klass.new
    page.load args
    yield page if block_given?
    sleep 0.5
  end

  def expect_page(klass)
    page = klass.new
    expect(page).to be_displayed
    expect(page).to_not have_content 'Request info'
    yield page if block_given?
    sleep 0.5
  end

  def snapshot
    screenshot_and_open_image
  end

  # source: https://robots.thoughtbot.com/automatically-wait-for-ajax-with-capybara
  def wait_for_ajax
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def wait_for_submit
    sleep 0.5
    wait_for_ajax
  end

  def finished_all_ajax_requests?
    return true unless page.current_url.start_with?("http://#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}")

    page.evaluate_script('jQuery.active').zero?
  end
end

class SitePrism::Page
  include FeatureSpecHelpers
end
