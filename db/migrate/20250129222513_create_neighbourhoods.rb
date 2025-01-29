class CreateNeighbourhoods < ActiveRecord::Migration[7.1]
  def change
    create_table :neighbourhoods do |t|
      t.string :name
      t.text :location

      t.timestamps
    end
  end
end
