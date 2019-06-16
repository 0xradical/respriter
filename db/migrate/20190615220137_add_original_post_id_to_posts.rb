class AddOriginalPostIdToPosts < ActiveRecord::Migration[5.2]
  def change
    add_reference :posts, :original_post, index: true
  end
end
