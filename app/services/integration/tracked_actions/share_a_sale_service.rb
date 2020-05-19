module Integration
  module TrackedActions
    class ShareASaleService < BaseService
      def run(date = 30.days.ago.to_date)
        connection = AffiliateHub.initialize_connection(:shareasale_v22, action: 'activity')
        date = date.kind_of?(String) ? date.to_date.strftime("%m/%d/%Y") : date.strftime("%m/%d/%Y")
        begin
          retries ||= 0
          connection.api(nil,
          mapper: -> (r) { Crack::XML.parse(r) },
          request_params: { query: { 'dateStart' => date } }) do |payload|
            [payload.dig('activitydetailsreport', 'activitydetailsreportrecord')].flatten.each do |resource|
              next unless resource
              next unless resource['transtype'] != 'Affiliate Payment'
              TrackedAction.find_or_initialize_by(compound_ext_id: "share_a_sale_#{resource['transid']}_#{resource['userid']}").tap do |action|
                action.ext_id           = "#{resource['transid']}_#{resource['userid']}"
                action.ext_click_date   = DateTime.strptime(resource['transdate'], "%m/%d/%Y %I:%M:%S %p").utc
                action.enrollment_id    = resource['affcomment']
                action.sale_amount      = resource['transamount']
                action.earnings_amount  = resource['commission']
                action.source           = 'share_a_sale'
                action.payload          = resource
              end.save
            end
          end
          log(:info, "Tracked actions successfully pulled! Bye".ansi(:green), ["ShareASale", "run.#{@run_id}", "retry.#{retries}"])
        rescue AffiliateHub::Connection::HTTPError => e
          log(:error, e.message.ansi(:red), ["ShareASale", "run.#{@run_id}", "retry.#{retries}"])
          sleep(120)
          retry if (retries += 1) < 3
        end
      end
    end
  end
end

