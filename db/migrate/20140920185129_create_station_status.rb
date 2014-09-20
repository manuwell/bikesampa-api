class CreateStationStatus < ActiveRecord::Migration
  def change
    create_table :station_status do |t|
      t.references :station

      t.string :online_status
      t.string :operation_status
      t.string :status
      t.string :busy_positions

      t.timestamps
    end
  end
end
