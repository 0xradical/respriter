class AlterEnrollmentTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :enrollments

    create_table :enrollments do |t|
      t.decimal :user_rating
      t.text :description
      t.string :tracked_url
      t.jsonb :tracking_data, default: {}
      t.references :payment
      t.references :user_account
      t.uuid       :course_id
      t.uuid       :click_id
      t.timestamps
    end

    add_index :enrollments, :tracking_data, using: 'gin'
    add_index :enrollments, :course_id
    add_index :enrollments, :click_id

  end
end
