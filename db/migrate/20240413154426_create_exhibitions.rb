class CreateExhibitions < ActiveRecord::Migration[7.1]
  def change
    create_table :exhibitions do |t|
      t.string :title
      t.text :description
      t.string :gallery_title
      t.timestamp :exhibition_start
      t.timestamp :exhibition_end

      t.timestamps
    end
  end
end
