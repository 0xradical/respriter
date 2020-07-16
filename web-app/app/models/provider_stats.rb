# frozen_string_literal: true

class ProviderStats < ApplicationRecord
  belongs_to :provider
  # materialized view
  def readonly?
    true
  end

  def self.refresh
    connection.execute('REFRESH MATERIALIZED VIEW app.provider_stats')
  end
end
