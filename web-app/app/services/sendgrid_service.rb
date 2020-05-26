# frozen_string_literal: true

class SendgridService
  require 'sendgrid-ruby'
  include SendGrid

  SENDGRID_SUPPRESSION_GROUPS = {
    digest:          '13995',
    newsletter:      '13996',
    promotions:      '13997',
    recommendations: '13998',
    reports:         '13999'
  }.freeze

  def initialize
    @sendgrid_api = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
  end

  def unsubscribe_from_group!(email, group_id)
    data = JSON.parse("{\"recipient_emails\": [\"#{email}\"]}")
    @sendgrid_api.client.asm.groups._(group_id).suppressions.post(request_body: data)
  end

  def unsubscribe_from_all_marketing_groups!(email)
    SENDGRID_SUPPRESSION_GROUPS.each_value do |group_id|
      SendgridUnsubscribeJob.enqueue(email, group_id)
    end
  end
end
