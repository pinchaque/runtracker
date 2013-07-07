class AddUidToActivities < ActiveRecord::Migration
  def up
    change_table :activities do |t|
      t.column(:uid, :string)
      t.index(:uid, :unique => true)
    end
  end
  def down
    remove_column :activities, :uid
  end
end
