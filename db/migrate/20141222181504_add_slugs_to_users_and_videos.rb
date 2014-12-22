class AddSlugsToUsersAndVideos < ActiveRecord::Migration
  def change
    add_column :users, :slug, :string
    add_column :videos, :slug, :string
  end
end
