class AddMonthAndYear < ActiveRecord::Migration
  def change
    add_column :schedules, :month, :integer
    add_column :schedules, :year, :integer
  end
end
