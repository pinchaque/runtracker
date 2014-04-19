class AddIndexToSumActivities < ActiveRecord::Migration
  def change
    add_index :sum_activities, :activity_id, :unique => true
  end

  def down
    drop_index :sum_activities, :activity_id
  end
end
