class CreateFavorites < ActiveRecord::Migration[5.1]
  def change
    create_table :favorites do |t|
      t.references :user_account, foreign_key: true
      t.references :course
      t.timestamps
    end
  end
end
