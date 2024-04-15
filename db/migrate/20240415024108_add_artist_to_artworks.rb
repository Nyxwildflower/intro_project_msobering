class AddArtistToArtworks < ActiveRecord::Migration[7.1]
  def change
    add_reference :artworks, :artist, null: true
  end
end
