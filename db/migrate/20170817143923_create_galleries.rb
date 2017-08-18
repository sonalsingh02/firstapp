class CreateGalleries < ActiveRecord::Migration[5.1]
  def change
    create_table :galleries do |t|
      t.string :name
      t.attachment :image
      t.string :timestamps
	  t.timestamps
    end
  end
end
