class AddIndexes < ActiveRecord::Migration
  def up
    change_table :activities do |t|
      t.index(:athlete_id)
    end
    
    change_table :activity_laps do |t|
      t.index(:activity_id)
    end

    change_table :activity_points do |t|
      t.index(:activity_lap_id)
    end
  end

  def down
    change_table :activities do |t|
      t.remove_index(:athlete_id)
    end
    
    change_table :activity_laps do |t|
      t.remove_index(:activity_id)
    end

    change_table :activity_points do |t|
      t.remove_index(:activity_lap_id)
    end
  end
end
