class Schedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.string :date
      t.string :presents
      t.string :title
      t.string :open
      t.text   :band
    end
  end
end
