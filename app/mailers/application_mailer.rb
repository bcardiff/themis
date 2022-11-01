class ApplicationMailer < ActionMailer::Base
  default from: Settings.smtp_default_options.from
  layout 'mailer'
end
