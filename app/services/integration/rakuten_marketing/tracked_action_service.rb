module Integration
  module RakutenMarketing
    class TrackedActionService

      class << self

        def run

          connection    = AffiliateHub.initialize_connection(:rakuten_affiliate_network_v1)
          credentials   = JSON.parse(connection.authorization[:body])

          api_connection = AffiliateHub.initialize_connection(:rakuten_affiliate_network_v1, {
            authorization_bearer_token: "Bearer #{credentials['access_token']}"
          })

          api_connection.events '', mapper: -> (r) { JSON.parse(r) } do |payload, code, header|
            payload.each do |resource|
              next unless resource['is_event'] == 'N'
              TrackedAction.new.tap do |action|
                action.ext_id           = resource['etransaction_id']
                action.ext_click_date   = resource['transaction_date']
                action.enrollment_id    = resource['u1']
                action.sale_amount      = resource['sale_amount']
                action.earnings_amount  = resource['commissions']
                action.ext_click_date   = resource['transaction_date']
                action.source           = 'rakuten'
                action.payload          = resource
              end.save!
            end
          end

        end

      end
    end
  end
end
