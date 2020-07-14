class ProviderPriceRange < ApplicationRecord
  belongs_to :provider
  # materialized view
  def readonly?
    true
  end

  def self.refresh
    connection.execute('REFRESH MATERIALIZED VIEW app.provider_price_ranges')
  end
end