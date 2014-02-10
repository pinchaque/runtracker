class SumActivity < ActiveRecord::Migration
  def up
    create_table :sum_activities do |t|
      t.timestamps
      t.column :activity_type_id, :integer, :null => false
      t.column :athlete_id, :integer, :null => false
      t.column :activity_id, :integer, :null => false
      t.column :name, :string, :null => false
      t.column :start_time, :datetime, :null => false
      t.column :end_time, :datetime, :null => false
      t.column :duration, :integer, :null => false
      t.column :distance, :float, :null => false
      t.column :elevation_gain, :float
      t.column :elevation_loss, :float
    end
  end

  def down
    drop_table :sum_activities
  end
end
