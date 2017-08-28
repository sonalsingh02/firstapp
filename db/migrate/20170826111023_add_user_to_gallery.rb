class AddUserToGallery < ActiveRecord::Migration[5.1]
  def change
    add_reference :galleries, :user, index: true
  end
end
