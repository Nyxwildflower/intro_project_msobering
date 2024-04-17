class RemoveApiIdFromArtists < ActiveRecord::Migration[7.1]
  def change
    remove_column :artists, :api_id, :integer
  end
end
