module Integration
  module TrackedActions
    class RakutenMarketingService < BaseService

      def run

        connection    = AffiliateHub.initialize_connection(:rakuten_affiliate_network_v1)
        credentials   = JSON.parse(connection.authorization[:body])

        api_connection = AffiliateHub.initialize_connection(:rakuten_affiliate_network_v1, {
          authorization_bearer_token: "Bearer #{credentials['access_token']}"
        })

        begin
          retries ||= 0
          api_connection.events '', mapper: -> (r) { JSON.parse(r) } do |payload, code, header|
            payload.each do |resource|
              next unless resource['is_event'] == 'N'
              TrackedAction.find_or_initialize_by(compound_ext_id: "rakuten_#{resource['etransaction_id']}").tap do |action|
                action.ext_id           = resource['etransaction_id']
                action.enrollment_id    = resource['u1']
                action.sale_amount      = resource['sale_amount']
                action.earnings_amount  = resource['commissions']
                action.ext_click_date   = Time.parse(resource['transaction_date']).utc
                action.ext_sku_id       = resource['sku_id']
                action.ext_product_name = resource['product_name']
                action.source           = 'rakuten'
                action.payload          = resource
              end.save
            end
          end
          log(:info, "Tracked actions successfully pulled! Bye".ansi(:green), ["RakutenMarketing", "run.#{@run_id}", "retry.#{retries}"])
        rescue AffiliateHub::Connection::HTTPError => e
          log(:error, e.message.ansi(:red), ["RakutenMarketing", "run.#{@run_id}", "retry.#{retries}"])
          sleep(120)
          retry if (retries += 1) < 3
        end

      end

    end
  end
end
