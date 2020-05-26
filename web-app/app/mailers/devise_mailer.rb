class DeviseMailer < Devise::Mailer
  include Devise::Controllers::UrlHelpers
  default from: 'Classpert <contact@classpert.com>',
          template_path: 'devise/mailer'
  layout 'mailer'
  helper :application, :subdomain
end