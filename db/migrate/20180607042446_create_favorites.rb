class CreateFavorites < ActiveRecord::Migration[5.1]
  def change
    create_table :favorites do |t|
      t.references :user_account, foreign_key: true
      t.references :course
      t.timestamps
    end

    add_index :favorites, :user_account_id, unique: true
    add_index :favorites, :course_id,       unique: true

  end
end
