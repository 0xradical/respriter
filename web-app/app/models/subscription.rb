# frozen_string_literal: true

class Subscription < ApplicationRecord
  belongs_to :profile

  def unsubscribe_from_everything!
    self.digest = false
    self.newsletter = false
    self.promotions = false
    self.recommendations = false
    self.reports = false
    save!

    email = profile&.user_account&.email
    SendgridService.new.unsubscribe_from_all_marketing_groups!(email)
  end

  def subscribe_to_everything!
    self.digest = true
    self.newsletter = true
    self.promotions = true
    self.recommendations = true
    self.reports = true
    save!
  end

  def save_unsubscribe_reasons!(json)
    unless %w[too_often not_relevant dislikes_email_marketing other].include?(json[:reason])
      raise I18n.t('unsubscriptions.show.alerts.no_option')
    end

    unsubscribe_reasons = {}
    unsubscribe_reasons[:reason] = json[:reason]

    if json[:reason] == 'other'
      unless json[:details] && json[:details] != ''
        raise I18n.t('unsubscriptions.show.alerts.no_details')
      end

      details = json[:details][0..199]
      unsubscribe_reasons[:details] = details
    end

    self.unsubscribe_reasons = unsubscribe_reasons
    self.unsubscribed_at = Time.zone.now
    save!
  end
end
