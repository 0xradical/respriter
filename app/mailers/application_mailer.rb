class ApplicationMailer < ActionMailer::Base
  default from: 'Classpert <contact@classpert.com>'
  layout 'mailer'
  helper :subdomain
end
