module Integration
  module TrackedActions
    class CommissionJunctionService < BaseService

      def run(start_date: Time.now.at_beginning_of_month, end_date: Time.now.at_end_of_month)
        connection = AffiliateHub.initialize_connection(:commission_junction_v3)

        start_date = start_date.iso8601
        end_date   = end_date.iso8601

        params = {
          query: {
            "date-type"   => 'posting',
            "start-date"  => start_date,
            "end-date"    => end_date,
            "requestor-cid" => ENV['CJ_REQUESTOR_CID']
          }
        }

        begin
          retries ||= 0
          connection.commissions(mapper: -> (r) { Crack::XML.parse(r) }, request_params: params) do |payload|
            break unless payload.dig('cj_api', 'commissions', 'total_matched').to_i > 0
            [payload['cj_api']['commissions']['commission']].flatten.each do |resource|
              TrackedAction.find_or_initialize_by(compound_ext_id: "commission_junction_#{resource['commission_id']}").tap do |action|
                action.ext_id           = resource['commission_id']
                action.ext_click_date   = resource['event_date']
                action.enrollment_id    = resource['sid']
                action.sale_amount      = resource['sale_amount']
                action.earnings_amount  = resource['commission_amount']
                action.source           = 'commission_junction'
                action.payload          = resource
              end.save!
            end
          end
          log(:info, "Tracked actions successfully pulled! Bye".ansi(:green), ["Commission Junction", "run.#{@run_id}", "retry.#{retries}"])
        rescue AffiliateHub::Connection::HTTPError => e
          log(:error, e.message.ansi(:red), ["Commission Junction", "run.#{@run_id}", "retry.#{retries}"])
          sleep(120)
          retry if (retries += 1) < 3
        end

      end
    end

  end
end
