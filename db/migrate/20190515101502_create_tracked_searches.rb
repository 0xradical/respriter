class CreateTrackedSearches < ActiveRecord::Migration[5.2]
  def change
    create_table :tracked_searches, id: :uuid, default: 'uuid_generate_v1()' do |t|
      t.string :version

      t.jsonb  :request
      t.jsonb  :results
      t.jsonb  :tracked_data

      t.timestamps
    end
  end
end
