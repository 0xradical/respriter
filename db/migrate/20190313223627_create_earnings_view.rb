class CreateEarningsView < ActiveRecord::Migration[5.1]
  def up
    execute(File.read(Rails.root.join('db/views/earnings_v01.sql')))
  end

  def down
    execute 'DROP VIEW earnings;'
  end
end