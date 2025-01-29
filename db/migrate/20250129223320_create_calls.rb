class CreateCalls < ActiveRecord::Migration[7.1]
  def change
    create_table :calls do |t|
      t.timestamp :call_time
      t.timestamp :closed_time
      t.string :incident_type
      t.boolean :vehicle_crash
      t.text :ward
      t.references :neighbourhood, null: false, foreign_key: true

      t.timestamps
    end
  end
end
