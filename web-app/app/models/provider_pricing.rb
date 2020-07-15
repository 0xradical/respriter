# frozen_string_literal: true

class ProviderPricing < ApplicationRecord
  belongs_to :provider
  # materialized view
  def readonly?
    true
  end

  def membership_types
    super || []
  end

  def price_range
    [min_price, max_price].compact.uniq
  end

  def has_trial?
    min_trial_price.present?
  end

  def self.refresh
    connection.execute('REFRESH MATERIALIZED VIEW app.provider_pricings')
  end
end
