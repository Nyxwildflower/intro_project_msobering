class CreateJoinTableArtworksExhibition < ActiveRecord::Migration[7.1]
  def change
    create_join_table :artworks, :exhibitions, :id => false do |t|
      # t.index [:artwork_id, :exhibition_id]
      # t.index [:exhibition_id, :artwork_id]
    end
  end
end
