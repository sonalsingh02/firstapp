class CreateContacts < ActiveRecord::Migration[5.1]
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :email
      t.string :mobile_number
      t.string :message

      t.timestamps
    end
  end
end
