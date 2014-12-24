class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title, :description, :large_cover, :small_cover, :slug
      t.integer :category_id
      t.timestamps
    end
  end
end

