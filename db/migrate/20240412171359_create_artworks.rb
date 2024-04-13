class CreateArtworks < ActiveRecord::Migration[7.1]
  def change
    create_table :artworks do |t|
      t.string :title
      t.string :year
      t.string :medium
      t.string :place_of_origin
      t.string :dimensions
      t.text :description
      t.string :alt_text
      t.integer :api_id

      t.timestamps
    end
  end
end
