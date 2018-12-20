module Integration
  module ImpactRadius
    class TrackedActionService

      class << self

        def run
          connection = AffiliateHub.initialize_connection(:impact_radius)
          url = "Mediapartners/#{ENV['IMPACT_RADIUS_ACCOUNT_SID']}/Actions.json?PageSize=100&Page=%{page}"
          page = 1

          loop do

            break if page.nil?
            connection.api(url % { page: page }, mapper: -> (r) { JSON.parse(r) }) do |payload, code, header|

              if payload['Actions'].empty?
                page = nil
                break
              end

              page += 1

              payload['Actions'].each do |resource|
                TrackedAction.new.tap do |action|
                  action.ext_id           = resource['Id']
                  action.ext_click_date   = Time.parse(resource['EventDate']).utc
                  action.enrollment_id    = resource['SharedId']
                  action.sale_amount      = resource['Amount']
                  action.earnings_amount  = resource['Payout']
                  action.source           = 'impact_radius'
                  action.payload          = resource
                end.upsert
              end

            end
          end

        end

      end
    end
  end
end
