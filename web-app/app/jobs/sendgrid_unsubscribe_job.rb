# frozen_string_literal: true

class SendgridUnsubscribeJob < Que::Job
  self.priority = 100

  def run(email, group_id)
    puts "Sending unsubscribe #{email} from group #{group_id} to Sengrid API"
    SendgridService.new.unsubscribe_from_group!(email, group_id)
  end
end
