class AddUseCoverImageToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :use_cover_image, :boolean, default: false
  end
end
