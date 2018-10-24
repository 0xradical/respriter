class CreateEnrollments < ActiveRecord::Migration[5.1]
  def change
    create_table :enrollments do |t|
      t.decimal :user_rating
      t.text :description
      t.string :tracked_url
      t.references :user_account
      t.references :course
      t.timestamps
    end

  end
end
