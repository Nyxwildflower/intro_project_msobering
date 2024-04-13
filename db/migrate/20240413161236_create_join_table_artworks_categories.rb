class CreateJoinTableArtworksCategories < ActiveRecord::Migration[7.1]
  def change
    create_join_table :artworks, :categories, :id => false do |t|
      # t.index [:artwork_id, :category_id]
      # t.index [:category_id, :artwork_id]
    end
  end
end
