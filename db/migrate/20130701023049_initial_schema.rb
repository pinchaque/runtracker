class InitialSchema < ActiveRecord::Migration
  def up
    create_table :athletes do |t|
      t.timestamps
      t.column :name, :string, :null => false
    end
    
    create_table :activity_types do |t|
      t.column :name, :string, :null => false
    end

    create_table :activities do |t|
      t.timestamps
      t.column :activity_type_id, :integer, :null => false
      t.column :athlete_id, :integer, :null => false
      t.column :name, :string, :null => false
      t.column :start_time, :datetime, :null => false
    end

    create_table :activity_laps do |t|
      t.column :activity_id, :integer, :null => false
      t.column :start_time, :datetime, :null => false
    end

    create_table :activity_points do |t|
      t.column :activity_lap_id, :integer, :null => false
      t.column :time, :datetime, :null => false
      t.column :latitude, :float, :null => false
      t.column :longitude, :float, :null => false
      t.column :elevation, :float
      t.column :accuracy, :float
      t.column :temperature, :float
      t.column :heart_rate, :integer
    end
  end

  def down
    drop_table :activity_points
    drop_table :activity_laps
    drop_table :activities
    drop_table :activity_types
    drop_table :athletes
  end
end
