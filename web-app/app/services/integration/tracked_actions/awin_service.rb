module Integration
  module TrackedActions
    class AwinService < BaseService

      def run(start_date: Time.now.at_beginning_of_month, end_date: Time.now.at_end_of_month)

        connection = AffiliateHub.initialize_connection(:awin)

        start_date = start_date.iso8601
        end_date   = end_date.iso8601

        params = {
          query: {
            "startDate" => start_date,
            "endDate"   => end_date,
            "dateType"  => 'transaction',
            "timezone"  => "UTC"
          }
        }

        begin
          retries ||= 0
          connection.transactions('/', mapper: ->(r) { JSON.parse(r) }, request_params: params) do |payload|
            payload.each do |resource|
              TrackedAction.find_or_initialize_by(compound_ext_id: "awin_#{resource['id']}")
              .tap do |action|
                action.ext_id           = resource['id']
                action.ext_click_date   = resource['clickDate']
                action.enrollment_id    = resource['clickRef']
                action.sale_amount      = resource.dig('saleAmount', 'amount')
                action.earnings_amount  = resource.dig('commissionAmount', 'amount')
                action.source           = 'awin'
                action.payload          = resource
              end.save
            end
          end
          log(:info, "Tracked actions successfully pulled! Bye".ansi(:green), ["Awin", "run.#{@run_id}", "retry.#{retries}"])
        rescue AffiliateHub::Connection::HTTPError => e
          log(:error, e.message.ansi(:red), ["Awin", "run.#{@run_id}", "retry.#{retries}"])
          sleep(120)
          retry if (retries += 1) < 3
        end

      end

    end
  end
end
