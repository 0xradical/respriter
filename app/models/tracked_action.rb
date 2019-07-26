class TrackedAction < ApplicationRecord

  upsert_keys [:compound_ext_id]
  belongs_to :enrollment, optional: true

  # the if is needed to emulate a normal after_create transition
  # using the upsert gem
  after_create :trigger_webhook, if: :id_changed?

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

    HTTParty.post(ENV['RAVEN_LORD_URI'], body: data, headers: { 'Content-Type' => 'application/json' })
  end

end
