class CreateStations < ActiveRecord::Migration
  def change
    create_table :stations do |t|
      t.float :lat
      t.float :long
      t.string :title
      t.integer :bikesampa_id

      t.integer :total_bikes
      t.string :address

      t.timestamps
    end
  end
end
