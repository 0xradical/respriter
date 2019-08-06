class TrackedAction < ApplicationRecord

  belongs_to :enrollment, optional: true

  after_create :trigger_webhook

  def trigger_webhook
    data = self.as_json(include: {
      enrollment: {
        include: {
          course: {
            include: {
              provider: {
                only: :name
              }
            },
            only: :name
          }
        },
        only: :tracking_data
      }
    }).to_json

    HTTParty.post(ENV['RAVEN_GOD_URI'], body: data, headers: { 'Content-Type' => 'application/json' })
  end

end
