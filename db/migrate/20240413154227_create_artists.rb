class CreateArtists < ActiveRecord::Migration[7.1]
  def change
    create_table :artists do |t|
      t.string :title
      t.integer :birth_date
      t.integer :death_date
      t.text :description
      t.references :artwork, null: false, foreign_key: true

      t.timestamps
    end
  end
end
